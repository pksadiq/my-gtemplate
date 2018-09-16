/* mgt-window.c
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

#define G_LOG_DOMAIN "mgt-window"

#include "config.h"

#include "mgt-settings.h"
#include "mgt-application.h"
#include "mgt-window.h"
#include "mgt-trace.h"

struct _MgtWindow
{
  GtkApplicationWindow parent_instance;

  GtkWidget *menu_button;
};

G_DEFINE_TYPE (MgtWindow, mgt_window, GTK_TYPE_APPLICATION_WINDOW)


static void
mgt_window_constructed (GObject *object)
{
  GtkWindow *window = (GtkWindow *)object;
  MgtSettings *settings;
  GdkRectangle geometry;

  settings = mgt_application_get_settings (MGT_APPLICATION_DEFAULT ());
  mgt_settings_get_window_geometry (settings, &geometry);

  gtk_window_set_default_size (window, geometry.width, geometry.height);
  gtk_window_move (window, geometry.x, geometry.y);

  if (mgt_settings_get_window_maximized (settings))
    gtk_window_maximize (window);

  G_OBJECT_CLASS (mgt_window_parent_class)->constructed (object);
}

static void
mgt_window_unmap (GtkWidget *widget)
{
  GtkWindow *window = (GtkWindow *)widget;
  MgtSettings *settings;
  GdkRectangle geometry;
  gboolean is_maximized;

  settings = mgt_application_get_settings (MGT_APPLICATION_DEFAULT ());
  is_maximized = gtk_window_is_maximized (window);
  mgt_settings_set_window_maximized (settings, is_maximized);

  if (is_maximized)
    return;

  gtk_window_get_size (window, &geometry.width, &geometry.height);
  gtk_window_get_position (window, &geometry.x, &geometry.y);
  mgt_settings_set_window_geometry (settings, &geometry);

  GTK_WIDGET_CLASS (mgt_window_parent_class)->unmap (widget);
}

static void
mgt_window_class_init (MgtWindowClass *klass)
{
  GObjectClass *object_class = G_OBJECT_CLASS (klass);
  GtkWidgetClass *widget_class = GTK_WIDGET_CLASS (klass);

  object_class->constructed = mgt_window_constructed;

  widget_class->unmap = mgt_window_unmap;

  gtk_widget_class_set_template_from_resource (widget_class,
                                               "/org/sadiqpk/GTemplate/"
                                               "ui/mgt-window.ui");

  gtk_widget_class_bind_template_child (widget_class, MgtWindow, menu_button);
}

static void
mgt_window_init (MgtWindow *self)
{
  gtk_widget_init_template (GTK_WIDGET (self));
}

GtkWidget *
mgt_window_new (GtkApplication *application)
{
  g_assert (GTK_IS_APPLICATION (application));

  return g_object_new (MGT_TYPE_WINDOW,
                       "application", application,
                       NULL);
}
