/* mgt-window.c
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
 * Authors:
 *   Mohammed Sadiq <sadiq@sadiqpk.org>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#define G_LOG_DOMAIN "mgt-window"

#ifdef HAVE_CONFIG_H
# include "config.h"
# include "version.h"
#endif

#include <glib/gi18n.h>

#include "mgt-settings.h"
#include "mgt-application.h"
#include "mgt-window.h"
#include "mgt-trace.h"

struct _MgtWindow
{
  GtkApplicationWindow parent_instance;

  GtkWidget *menu_button;
  GtkWidget *menu_help_button;
};

G_DEFINE_TYPE (MgtWindow, mgt_window, GTK_TYPE_APPLICATION_WINDOW)


static void
mgt_window_show_about (MgtWindow *self)
{
  const gchar *authors[] = {
    "Mohammed Sadiq https://www.sadiqpk.org",
    NULL
  };

  g_assert (MGT_IS_WINDOW (self));

  gtk_show_about_dialog (GTK_WINDOW (self),
                         "program-name", _("My GTemplate"),
                         "website", "https://www.sadiqpk.org/projects/my-gtemplate.html",
                         "version", PACKAGE_VCS_VERSION,
                         "copyright", "Copyright \xC2\xA9 2019 Mohammed Sadiq",
                         "license-type", GTK_LICENSE_GPL_3_0,
                         "authors", authors,
                         "logo-icon-name", PACKAGE_ID,
                         "translator-credits", _("translator-credits"),
                         NULL);
}

static void
mgt_window_constructed (GObject *object)
{
  MgtWindow *self = (MgtWindow *)object;
  GtkWindow *window = (GtkWindow *)object;
  MgtSettings *settings;
  GdkRectangle geometry;

  settings = mgt_application_get_settings (MGT_APPLICATION_DEFAULT ());
  mgt_settings_get_window_geometry (settings, &geometry);
  gtk_window_set_default_size (window, geometry.width, geometry.height);

  if (geometry.width > -1)
    gtk_window_move (window, geometry.x, geometry.y);

  if (mgt_settings_get_window_maximized (settings))
    gtk_window_maximize (window);

#ifndef PACKAGE_HELP_ENABLED
  gtk_widget_hide (self->menu_help_button);
#endif

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
  gtk_widget_class_bind_template_child (widget_class, MgtWindow, menu_help_button);

  gtk_widget_class_bind_template_callback (widget_class, mgt_window_show_about);
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
