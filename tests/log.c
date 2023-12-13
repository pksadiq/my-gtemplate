/* utils.c
 *
 * Copyright 2024 Mohammed Sadiq <sadiq@sadiqpk.org>
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

#undef NDEBUG
#undef G_DISABLE_ASSERT
#undef G_DISABLE_CHECKS
#undef G_DISABLE_CAST_CHECKS
#undef G_LOG_DOMAIN

#include <glib.h>

#include "mgt-log.h"

static void
test_log_anonymize (void)
{
  GString *str;
  const char *strings[][2] = {
    {"hunter2", "h#####2"},  /* Use ******* instead? */
    {"alice@example.com", "a###e@e#####e.c#m"},
    {"@bob:example.com", "@b#b:e#####e.c#m"},
    {"127.0.0.1", "1#7.0.0.1"},
    {"+919995199951", "+9##########1"},
    {"2001:db8::2:1", "2##1:d#8::2:1"},
    {"test string", "t##t s####g"},
    {"русский язык", "р#####й я##к"},
    {"മലയാളം", "മ#യാളം"},
  };

  str = g_string_new (NULL);

  for (guint i = 0; i < G_N_ELEMENTS (strings); i++) {
    g_string_set_size (str, 0);
    mgt_log_anonymize_value (str, strings[i][0]);
    g_assert_cmpstr (str->str, ==, strings[i][1]);
  }

}

int
main (int   argc,
      char *argv[])
{
  g_test_init (&argc, &argv, NULL);

  g_test_add_func ("/log/anonymize", test_log_anonymize);

  return g_test_run ();
}
