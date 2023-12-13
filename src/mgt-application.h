/* mgt-application.h
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

#include <adwaita.h>

#include "mgt-settings.h"

G_BEGIN_DECLS

#define MGT_APPLICATION_DEFAULT() ((MgtApplication *)g_application_get_default ())
#define MGT_TYPE_APPLICATION (mgt_application_get_type ())

G_DECLARE_FINAL_TYPE (MgtApplication, mgt_application, MGT, APPLICATION, AdwApplication)

MgtApplication *mgt_application_new    (void);

G_END_DECLS
