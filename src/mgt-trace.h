/* mgt-trace.h
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

#pragma once

#include "config.h"

#include <glib.h>

G_BEGIN_DECLS

/**
 * MGT_LOG_LEVEL_TRACE: (skip)
 */
#ifndef MGT_LOG_LEVEL_TRACE
# define MGT_LOG_LEVEL_TRACE ((GLogLevelFlags)(1 << G_LOG_LEVEL_USER_SHIFT))
#endif

#ifdef ENABLE_TRACING
# define MGT_TRACE_MSG(fmt, ...)                                    \
  g_log (G_LOG_DOMAIN, MGT_LOG_LEVEL_TRACE, "  MSG: %s():%d: " fmt, \
         G_STRFUNC, __LINE__, ## __VA_ARGS__)
# define MGT_PROBE                                            \
  g_log (G_LOG_DOMAIN, MGT_LOG_LEVEL_TRACE, "PROBE: %s():%d", \
         G_STRFUNC, __LINE__)
# define MGT_TODO(_msg)                                           \
  g_log (G_LOG_DOMAIN, MGT_LOG_LEVEL_TRACE, " TODO: %s():%d: %s", \
         G_STRFUNC, __LINE__, _msg)
# define MGT_ENTRY                                            \
  g_log (G_LOG_DOMAIN, MGT_LOG_LEVEL_TRACE, "ENTRY: %s():%d", \
         G_STRFUNC, __LINE__)
# define MGT_EXIT                                               \
  G_STMT_START {                                                \
    g_log (G_LOG_DOMAIN, MGT_LOG_LEVEL_TRACE, " EXIT: %s():%d", \
           G_STRFUNC, __LINE__);                                \
    return;                                                     \
  } G_STMT_END
# define MGT_GOTO(_l)                                                    \
  G_STMT_START {                                                         \
    g_log (G_LOG_DOMAIN, MGT_LOG_LEVEL_TRACE, " GOTO: %s():%d ("#_l ")", \
           G_STRFUNC, __LINE__);                                         \
    goto _l;                                                             \
  } G_STMT_END
# define MGT_RETURN(_r)                                          \
  G_STMT_START {                                                 \
    g_log (G_LOG_DOMAIN, MGT_LOG_LEVEL_TRACE, " EXIT: %s():%d ", \
           G_STRFUNC, __LINE__);                                 \
    return _r;                                                   \
  } G_STMT_END
#else
# define MGT_TODO(_msg)
# define MGT_PROBE
# define MGT_TRACE_MSG(fmt, ...)
# define MGT_ENTRY
# define MGT_GOTO(_l)   goto _l
# define MGT_EXIT       return
# define MGT_RETURN(_r) return _r
#endif

G_END_DECLS
