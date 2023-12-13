/* mgt-window.h
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

#pragma once

#include <gtk/gtk.h>

#include "mgt-settings.h"

G_BEGIN_DECLS

#define MGT_TYPE_WINDOW (mgt_window_get_type ())

G_DECLARE_FINAL_TYPE (MgtWindow, mgt_window, MGT, WINDOW, GtkApplicationWindow)

GtkWidget *mgt_window_new (GtkApplication *application,
                           MgtSettings    *settings);

G_END_DECLS
