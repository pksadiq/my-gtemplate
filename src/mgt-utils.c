/* mgt-utils.c
 *
 * Copyright 2023 Mohammed Sadiq <sadiq@sadiqpk.org>
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

#define G_LOG_DOMAIN "mgt-utils"

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#include "mgt-utils.h"

/**
 * SECTION: mgt-utils
 * @title: mgt-utils
 * @short_description: Generic functions
 * @include: "mgt-utils.h"
 *
 * Generic functions that doesn’t fit elsewhere.
 */

/**
 * mgt_utils_get_main_thread:
 *
 * Returns the thread-id of the main thread.  Useful
 * to check if current thread is the main UI thread
 * or not.  This is used by MGT_IS_MAIN_THREAD() macro.
 *
 * The first call to this function should be done in the
 * UI thread.  The <function>main()</function> function
 * is a good place to do so.
 *
 * Returns: (transfer none): a #GThread
 */
GThread *
mgt_utils_get_main_thread (void)
{
  static GThread *main_thread;

  if (G_UNLIKELY (main_thread == NULL))
    main_thread = g_thread_self ();

  return main_thread;
}
