/*
 * Copyright (C) 2003-2005 by the gtk2-perl team (see the file AUTHORS for the
 * full list)
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Library General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or (at your
 * option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307  USA.
 *
 * THIS IS A PRIVATE HEADER FOR USE ONLY IN Gtk2 ITSELF.
 *
 * $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/Gtk2/gtk2perl-private.h,v 1.1 2005/07/10 12:22:11 kaffeetisch Exp $
 */

#ifndef _GTK2PERL_PRIVATE_H_
#define _GTK2PERL_PRIVATE_H_

#include "gtk2perl.h"

/* Implemented in GtkItemFactory.xs. */
GPerlCallback * gtk2perl_translate_func_create (SV * func, SV * data);
gchar * gtk2perl_translate_func (const gchar *path, gpointer data);

#if GTK_CHECK_VERSION (2, 6, 0)
/* Implemented in GtkTreeView.xs. */
GPerlCallback * gtk2perl_tree_view_row_separator_func_create (SV * func,
							      SV * data);
gboolean gtk2perl_tree_view_row_separator_func (GtkTreeModel *model,
				                GtkTreeIter  *iter,
				                gpointer      data);
#endif

#endif /* _GTK2PERL_PRIVATE_H_ */