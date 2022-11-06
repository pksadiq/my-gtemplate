/* -*- mode: c; c-basic-offset: 2; indent-tabs-mode: nil; -*- */
/* main.c
 *
 * Copyright 2022 Mohammed Sadiq <sadiq@sadiqpk.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author(s):
 *   Mohammed Sadiq <sadiq@sadiqpk.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#include <gtk/gtk.h>
#include <libintl.h>
#include <locale.h>

#include "mgt-utils.h"
#include "mgt-application.h"
#include "mgt-log.h"

static void
show_backtrace (int signum)
{
  /* Log only if we have set some verbosity so that the trace
   * shall be shown only if the user have explicitly asked for.
   * Thus avoid logging sensitive information to system log
   * without user's knowledge.
   */
  if (mgt_log_get_verbosity () > 0)
    g_on_error_stack_trace (g_get_prgname ());

  g_print ("signum %d: %s\n", signum, g_strsignal (signum));

  exit (128 + signum);
}

static void
enable_backtrace (void)
{
  const char *env;

  env = g_getenv ("LD_PRELOAD");

  /* Don't log backtrace if run inside valgrind */
  if (env && (strstr (env, "/valgrind/") || strstr (env, "/vgpreload")))
    return;

  signal (SIGABRT, show_backtrace);
  signal (SIGTRAP, show_backtrace);

#ifndef __has_feature
#  define __has_feature(x) (0)
#endif

#if __has_feature (address_sanitizer) ||        \
  defined(__SANITIZE_ADDRESS__) ||              \
  defined(__SANITIZE_THREAD__)
  return;
#endif

  /* Trap SIGSEGV only if not compiled with sanitizers */
  /* as sanitizers shall handle this better. */
  /* fixme: How to check if leak sanitizer is enabled? */
  signal (SIGSEGV, show_backtrace);
}

int
main (int   argc,
      char *argv[])
{
  g_autoptr(MgtApplication) application = NULL;

  g_assert (MGT_IS_MAIN_THREAD ());

  g_set_prgname (PACKAGE_NAME);
  enable_backtrace ();

  mgt_log_init ();

  application = mgt_application_new ();
  setlocale (LC_ALL, "");
  bindtextdomain (GETTEXT_PACKAGE, PACKAGE_LOCALE_DIR);
  bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
  textdomain (GETTEXT_PACKAGE);

  return g_application_run (G_APPLICATION (application), argc, argv);
}
