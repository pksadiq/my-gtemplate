/* utils.c
 *
 * Copyright 2018 Mohammed Sadiq <sadiq@sadiqpk.org>
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
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include <glib.h>

#include "mgt-utils.h"

gpointer
test_main_thread (gpointer user_data)
{
  /*
   * This is being run in a different thread.
   * So this should return false
   */
  g_assert_false (MGT_IS_MAIN_THREAD ());

  return NULL;
}

static void
test_thread_utils (void)
{
  g_autoptr(GThread) thread = NULL;

  /*
   * This is the first call to MGT_IS_MAIN_THREAD().
   * So this will always be true
   */
  g_assert_true (MGT_IS_MAIN_THREAD ());

  thread = g_thread_new ("test-thread", test_main_thread, NULL);
  g_thread_join (thread);
}

int
main (int   argc,
      char *argv[])
{
  g_test_init (&argc, &argv, NULL);

  g_test_add_func ("/thread/utils", test_thread_utils);

  return g_test_run ();
}
