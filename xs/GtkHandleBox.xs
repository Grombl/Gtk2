/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the 
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
 * Boston, MA  02111-1307  USA.
 *
 * $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/Gtk2/xs/GtkHandleBox.xs,v 1.4 2003/09/14 20:07:43 rwmcfa1 Exp $
 */

#include "gtk2perl.h"

MODULE = Gtk2::HandleBox	PACKAGE = Gtk2::HandleBox	PREFIX = gtk_handle_box_

## GtkWidget* gtk_handle_box_new (void)
GtkWidget *
gtk_handle_box_new (class)
	SV * class
    C_ARGS:
	/* void */
    CLEANUP:
	UNUSED(class);

## void gtk_handle_box_set_shadow_type (GtkHandleBox *handle_box, GtkShadowType type)
void
gtk_handle_box_set_shadow_type (handle_box, type)
	GtkHandleBox * handle_box
	GtkShadowType  type

## GtkShadowType gtk_handle_box_get_shadow_type (GtkHandleBox *handle_box)
GtkShadowType
gtk_handle_box_get_shadow_type (handle_box)
	GtkHandleBox * handle_box

## void gtk_handle_box_set_handle_position (GtkHandleBox *handle_box, GtkPositionType position)
void
gtk_handle_box_set_handle_position (handle_box, position)
	GtkHandleBox    * handle_box
	GtkPositionType   position

## GtkPositionType gtk_handle_box_get_handle_position(GtkHandleBox *handle_box)
GtkPositionType
gtk_handle_box_get_handle_position (handle_box)
	GtkHandleBox * handle_box

## void gtk_handle_box_set_snap_edge (GtkHandleBox *handle_box, GtkPositionType edge)
void
gtk_handle_box_set_snap_edge (handle_box, edge)
	GtkHandleBox    * handle_box
	GtkPositionType   edge

## GtkPositionType gtk_handle_box_get_snap_edge (GtkHandleBox *handle_box)
GtkPositionType
gtk_handle_box_get_snap_edge (handle_box)
	GtkHandleBox * handle_box
