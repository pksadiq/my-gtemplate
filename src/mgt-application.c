/* mgt-application.c
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

#define G_LOG_DOMAIN "mgt-application"

#include "config.h"

#include <glib/gi18n.h>

#include "mgt-utils.h"
#include "mgt-window.h"
#include "mgt-application.h"
#include "mgt-trace.h"

/**
 * SECTION: mgt-application
 * @title: MgtApplication
 * @short_description: Base Application class
 * @include: "mgt-application.h"
 */

struct _MgtApplication
{
  GtkApplication  parent_instance;

  GtkCssProvider *css_provider;
  MgtSettings *settings;
};

G_DEFINE_TYPE (MgtApplication, mgt_application, GTK_TYPE_APPLICATION)


static GOptionEntry cmd_options[] = {
  {
    "quit", 0, G_OPTION_FLAG_NONE, G_OPTION_ARG_NONE, NULL,
    N_("Quit all running instances of the application"), NULL
  },
  {
    "version", 0, G_OPTION_FLAG_NONE, G_OPTION_ARG_NONE, NULL,
    N_("Show release version"), NULL
  },
  { NULL }
};

static void
mgt_application_show_about (GSimpleAction *action,
                            GVariant      *parameter,
                            gpointer       user_data)
{
  GtkApplication *application = GTK_APPLICATION (user_data);
  const gchar *authors[] = {
    "Mohammed Sadiq <sadiq@sadiqpk.org>",
    NULL
  };

  gtk_show_about_dialog (gtk_application_get_active_window (application),
                         "program-name", _("My GTemplate"),
                         "website", "https://www.sadiqpk.org/projects/my-gtemplate.html",
                         "version", PACKAGE_VERSION,
                         "copyright", "Copyright \xC2\xA9 2018 Mohammed Sadiq",
                         "license-type", GTK_LICENSE_GPL_3_0,
                         "authors", authors,
                         "logo-icon-name", "org.sadiqpk.GTemplate",
                         "translator-credits", _("translator-credits"),
                         NULL);
}

static void
mgt_application_show_help (GSimpleAction *action,
                           GVariant      *parameter,
                           gpointer       user_data)
{
  GtkWindow *window;
  g_autoptr(GError) error = NULL;

  window = gtk_application_get_active_window (GTK_APPLICATION (user_data));

  if (!gtk_show_uri_on_window (window,
                               "help:org.sadiqpk.GTemplate",
                               GDK_CURRENT_TIME,
                               &error))
    g_warning ("Failed to launch help: %s", error->message);
}

static void
mgt_application_finalize (GObject *object)
{
  MgtApplication *self = (MgtApplication *)object;

  g_clear_object (&self->settings);
  g_clear_object (&self->css_provider);

  G_OBJECT_CLASS (mgt_application_parent_class)->finalize (object);
}

static gint
mgt_application_handle_local_options (GApplication *application,
                                      GVariantDict *options)
{
  if (g_variant_dict_contains (options, "version"))
    {
      g_print ("%s %s\n", PACKAGE_NAME, PACKAGE_VERSION);
      return 0;
    }

  return -1;
}

static void
mgt_application_add_actions (MgtApplication *self)
{
  static const GActionEntry application_entries[] = {
    { "about", mgt_application_show_about },
    { "help", mgt_application_show_help   },
  };

  struct
  {
    const gchar *action;
    const gchar *accel[2];
  } accels[] = {
    { "app.help", { "F1", NULL } },
  };

  g_assert (MGT_IS_APPLICATION (self));

  g_action_map_add_action_entries (G_ACTION_MAP (self), application_entries,
                                   G_N_ELEMENTS (application_entries), self);

  for (gsize i = 0; i < G_N_ELEMENTS (accels); i++)
    gtk_application_set_accels_for_action (GTK_APPLICATION (self),
                                           accels[i].action, accels[i].accel);
}

static void
mgt_application_startup (GApplication *application)
{
  MgtApplication *self = (MgtApplication *)application;

  G_APPLICATION_CLASS (mgt_application_parent_class)->startup (application);

  mgt_application_add_actions (self);
  g_set_application_name (_("My GTemplate"));
  gtk_window_set_default_icon_name ("org.sadiqpk.GTemplate");

  self->settings = mgt_settings_new ("org.sadiqpk.GTemplate");
  self->css_provider = gtk_css_provider_new ();
  gtk_css_provider_load_from_resource (self->css_provider,
                                       "/org/sadiqpk/GTemplate/css/gtk.css");

  gtk_style_context_add_provider_for_display (gdk_display_get_default (),
                                              GTK_STYLE_PROVIDER (self->css_provider),
                                              GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
}

static gint
mgt_application_command_line (GApplication            *application,
                              GApplicationCommandLine *command_line)
{
  GVariantDict *options;

  options = g_application_command_line_get_options_dict (command_line);

  if (g_variant_dict_contains (options, "quit"))
    {
      g_application_quit (application);
      return 0;
    }

  g_application_activate (application);

  return 0;
}

static void
mgt_application_activate (GApplication *application)
{
  GtkApplication *app = (GtkApplication *)application;
  GtkWindow *window;

  g_assert (GTK_IS_APPLICATION (app));

  window = gtk_application_get_active_window (app);

  if (window == NULL)
    window = GTK_WINDOW (mgt_window_new (app));

  gtk_window_present (window);
}

static void
mgt_application_class_init (MgtApplicationClass *klass)
{
  GApplicationClass *application_class = G_APPLICATION_CLASS (klass);
  GObjectClass *object_class = G_OBJECT_CLASS (klass);

  object_class->finalize = mgt_application_finalize;

  application_class->handle_local_options = mgt_application_handle_local_options;
  application_class->startup = mgt_application_startup;
  application_class->command_line = mgt_application_command_line;
  application_class->activate = mgt_application_activate;

  g_assert (MGT_IS_MAIN_THREAD ());
}

static void
mgt_application_init (MgtApplication *self)
{
  g_application_add_main_option_entries (G_APPLICATION (self), cmd_options);
}

MgtApplication *
mgt_application_new (void)
{
  return g_object_new (MGT_TYPE_APPLICATION,
                       "application-id", "org.sadiqpk.GTemplate",
                       "flags", G_APPLICATION_HANDLES_COMMAND_LINE,
                       NULL);
}

/**
 * mgt_application_get_settings:
 * @self: A #MgtApplication
 *
 * Get the default #MgtSettings.
 *
 * Returns: (transfer none): A #MgtSettings
 */
MgtSettings *
mgt_application_get_settings (MgtApplication *self)
{
  g_return_val_if_fail (MGT_IS_APPLICATION (self), NULL);

  return self->settings;
}
