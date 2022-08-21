/* -*- mode: c; c-basic-offset: 2; indent-tabs-mode: nil; -*- */
/* library.c
 *
 * Copyright 2022 Mohammed Sadiq <sadiq@sadiqpk.org>
 *
 * Author(s):
 *   Mohammed Sadiq <sadiq@sadiqpk.org>
 *
 * SPDX-License-Identifier: GPL-2-or-later OR CC0-1.0
 */

#include <adwaita.h>

#include "mgt-window.h"

void __attribute__((constructor)) ensure_types (void);

void
__attribute__((constructor)) ensure_types (void)
{
  gtk_init ();
  adw_init ();

  /* fixme: Why do gtk warn with the following code? */
  /* g_type_ensure (MGT_TYPE_WINDOW); */
}
