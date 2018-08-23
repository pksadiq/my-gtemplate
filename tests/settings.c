/* settings.c
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

#include "mgt-settings.h"

static void
test_geometry_settings (void)
{
  g_autoptr(MgtSettings) settings = NULL;
  GdkRectangle geometry = {100, 200, 300, 400};
  GdkRectangle reset = {0, 0, 0, 0};
  GdkRectangle out;
  gboolean is_maximized;

  settings = mgt_settings_new ("org.sadiqpk.GTemplate");
  g_assert (MGT_IS_SETTINGS (settings));

  mgt_settings_set_window_maximized (settings, 0);
  is_maximized = mgt_settings_get_window_maximized (settings);
  g_assert_false (is_maximized);

  mgt_settings_set_window_maximized (settings, 1);
  is_maximized = mgt_settings_get_window_maximized (settings);
  g_assert_true (is_maximized);

  /*
   * gbooleans are typedef to gint.  So test if non boolean
   * values are clamped.
   */
  mgt_settings_set_window_maximized (settings, 100);
  is_maximized = mgt_settings_get_window_maximized (settings);
  g_assert_cmpint (is_maximized, ==, 1);

  mgt_settings_set_window_geometry (settings, &geometry);
  mgt_settings_get_window_geometry (settings, &out);
  g_assert_cmpint (out.x, ==, geometry.x);
  g_assert_cmpint (out.y, ==, geometry.y);
  g_assert_cmpint (out.width, ==, geometry.width);
  g_assert_cmpint (out.height, ==, geometry.height);
  out = reset;

  /* Save the settings, create a new object, and check again */
  g_object_unref (settings);
  settings = mgt_settings_new ("org.sadiqpk.GTemplate");
  g_assert (MGT_IS_SETTINGS (settings));

  is_maximized = mgt_settings_get_window_maximized (settings);
  g_assert_cmpint (is_maximized, ==, 1);

  mgt_settings_get_window_geometry (settings, &out);
  g_assert_cmpint (out.x, ==, geometry.x);
  g_assert_cmpint (out.y, ==, geometry.y);
  g_assert_cmpint (out.width, ==, geometry.width);
  g_assert_cmpint (out.height, ==, geometry.height);
}

static void
test_first_run_settings (void)
{
  g_autoptr(MgtSettings) settings = NULL;
  gboolean is_first_run;

  settings = mgt_settings_new ("org.sadiqpk.GTemplate");
  g_assert (MGT_IS_SETTINGS (settings));

  is_first_run = mgt_settings_get_is_first_run (settings);
  g_assert_true (is_first_run);

  /* Save the settings, create a new object, and check again */
  g_object_unref (settings);
  settings = mgt_settings_new ("org.sadiqpk.GTemplate");
  g_assert (MGT_IS_SETTINGS (settings));

  is_first_run = mgt_settings_get_is_first_run (settings);
  g_assert_false (is_first_run);
}

int
main (int   argc,
      char *argv[])
{
  g_test_init (&argc, &argv, NULL);

  /*
   * "/first_run/settings" should be the first test as it is supposed
   * to be changing only on the first run.  Changing this order will
   * result in test failure.
   */
  g_test_add_func ("/first_run/settings", test_first_run_settings);
  g_test_add_func ("/geometry/settings", test_geometry_settings);

  return g_test_run ();
}
