/* -*- mode: c; c-basic-offset: 2; indent-tabs-mode: nil; -*- */
/* mgt-settings.h
 *
 * Copyright 2019 Mohammed Sadiq <sadiq@sadiqpk.org>
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

G_BEGIN_DECLS

#define MGT_TYPE_SETTINGS (mgt_settings_get_type ())

G_DECLARE_FINAL_TYPE (MgtSettings, mgt_settings, MGT, SETTINGS, GSettings)

MgtSettings *mgt_settings_new                  (void);

gboolean     mgt_settings_get_is_first_run     (MgtSettings *self);
gboolean     mgt_settings_get_window_maximized (MgtSettings *self);
void         mgt_settings_set_window_maximized (MgtSettings *self,
                                                gboolean     maximized);
void         mgt_settings_get_window_geometry  (MgtSettings  *self,
                                                GdkRectangle *geometry);
void         mgt_settings_set_window_geometry  (MgtSettings  *self,
                                                GdkRectangle *geometry);
G_END_DECLS
