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
 * $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/Gtk2/xs/GtkAccelGroup.xs,v 1.8 2003/09/14 20:07:43 rwmcfa1 Exp $
 */

#include "gtk2perl.h"

typedef struct {
	GClosure * closure;
	const char * sv_str;
} FindClosureData;

gboolean
find_closure (GtkAccelKey * key,
              GClosure * closure,
	      gpointer data)
{
	GPerlClosure * gpc = (GPerlClosure*) closure;
	FindClosureData * cd = (FindClosureData*) data;

	if (strEQ (cd->sv_str, SvPV_nolen (gpc->callback))) {
		cd->closure = closure;
		return TRUE;
	} else
		return FALSE;
}

MODULE = Gtk2::AccelGroup	PACKAGE = Gtk2::AccelGroup	PREFIX = gtk_accel_group_

## GtkAccelGroup* gtk_accel_group_new (void)
GtkAccelGroup *
gtk_accel_group_new (class)
	SV * class
    C_ARGS:
	/*void*/
    CLEANUP:
	UNUSED(class);

## void gtk_accel_group_lock (GtkAccelGroup *accel_group)
void
gtk_accel_group_lock (accel_group)
	GtkAccelGroup * accel_group

## void gtk_accel_group_unlock (GtkAccelGroup *accel_group)
void
gtk_accel_group_unlock (accel_group)
	GtkAccelGroup * accel_group

## void gtk_accel_group_connect (GtkAccelGroup *accel_group, guint accel_key, GdkModifierType accel_mods, GtkAccelFlags accel_flags, GClosure *closure)
void
gtk_accel_group_connect (accel_group, accel_key, accel_mods, accel_flags, func)
	GtkAccelGroup   * accel_group
	guint             accel_key
	GdkModifierType   accel_mods
	GtkAccelFlags     accel_flags
	SV              * func
    PREINIT:
	GClosure        * closure;
    CODE:
	closure = gperl_closure_new (func, NULL, FALSE);
	gtk_accel_group_connect (accel_group, accel_key, accel_mods,
	                         accel_flags, closure);
	/* i would swear until i was blue in the face that this unref
	 * is the right thing to do, but with it in there i get a critical
	 * assertion failure from glib when i try to disconnect the closure,
	 * saying that the refcount was zero somehow. */
	//g_closure_unref (closure);

## void gtk_accel_group_connect_by_path (GtkAccelGroup *accel_group, const gchar *accel_path, GClosure *closure)
void
gtk_accel_group_connect_by_path (accel_group, accel_path, func)
	GtkAccelGroup * accel_group
	const gchar   * accel_path
	SV            * func
    PREINIT:
	GClosure      * closure;
    CODE:
	closure = gperl_closure_new (func, NULL, FALSE);
	gtk_accel_group_connect_by_path (accel_group, accel_path, closure);
	/* i wonder if we get the same problem here as above? */
	g_closure_unref (closure);

# this will not work quite as advertised --- a GClosure can be
# attached to only one GtkAccelGroup, but we'll be creating a new
# closure on each call to connect, so we can have many closures
# on the same perl func.  we'll just disconnect the first one,
# and you can call this in a loop until it stops returning true. 
## gboolean gtk_accel_group_disconnect (GtkAccelGroup *accel_group, GClosure *closure)
gboolean
gtk_accel_group_disconnect (accel_group, func)
	GtkAccelGroup * accel_group
	SV * func
    PREINIT:
	FindClosureData data;
    CODE:
	data.closure = NULL;
	data.sv_str = SvPV_nolen (func);
	if (gtk_accel_group_find (accel_group, find_closure, &data)) {
		RETVAL = gtk_accel_group_disconnect (accel_group,
		                                     data.closure);
	} else
		RETVAL = 0;
    OUTPUT:
	RETVAL

## gboolean gtk_accel_group_disconnect_key (GtkAccelGroup *accel_group, guint accel_key, GdkModifierType accel_mods)
gboolean
gtk_accel_group_disconnect_key (accel_group, accel_key, accel_mods)
	GtkAccelGroup   * accel_group
	guint             accel_key
	GdkModifierType   accel_mods

## gboolean gtk_accel_groups_activate (GObject *object, guint accel_key, GdkModifierType accel_mods)
gboolean
gtk_accel_groups_activate (object, accel_key, accel_mods)
	GObject         * object
	guint             accel_key
	GdkModifierType   accel_mods

## GSList* gtk_accel_groups_from_object (GObject *object)
void
gtk_accel_groups_from_object (object)
	GObject * object
    PREINIT:
	GSList * groups, * i;
    PPCODE:
	groups = gtk_accel_groups_from_object (object);
	for (i = groups ; i != NULL ; i = i->next)
		XPUSHs (sv_2mortal (newSVGtkAccelGroup (i->data)));
	/* according to the source, we should not free the list */

# no typemap for GtkAccelKey, no boxed support, either
## GtkAccelKey* gtk_accel_group_find (GtkAccelGroup *accel_group, gboolean (*find_func) (GtkAccelKey *key, GClosure *closure, gpointer data), gpointer data)
#GtkAccelKey *
#gtk_accel_group_find (accel_group, key, closure, *, data)
#	GtkAccelGroup * accel_group
#	gboolean        (*find_func) (GtkAccelKey *key, GClosure *closure, gpointer data)
#	gpointer        data

# this will not work as advertised; implementation details of the C version
# guarantee that a single closure can be connected to only one accel group,
# but we will create a new closure for each function we connect --- 
# potentially many closures for one perl function.  thus, there is not a
# one to one mapping that would return a certain accel group for a given
# closure.  ... which means this function would be rather pointless at
# the perl level.
## GtkAccelGroup* gtk_accel_group_from_accel_closure (GClosure *closure)

MODULE = Gtk2::AccelGroup	PACKAGE = Gtk2::Accelerator	PREFIX = gtk_accelerator_

## void gtk_accelerator_parse (const gchar *accelerator, guint *accelerator_key, GdkModifierType *accelerator_mods)
void
gtk_accelerator_parse (class, accelerator)
	SV              * class
	const gchar     * accelerator
    PREINIT:
	guint           accelerator_key;
	GdkModifierType accelerator_mods;
    PPCODE:
	UNUSED(class);
	gtk_accelerator_parse (accelerator, &accelerator_key, 
	                       &accelerator_mods);
	XPUSHs (sv_2mortal (newSVuv (accelerator_key)));
	XPUSHs (sv_2mortal (newSVGdkModifierType (accelerator_mods)));

## gchar* gtk_accelerator_name (guint accelerator_key, GdkModifierType accelerator_mods)
gchar_own *
gtk_accelerator_name (class, accelerator_key, accelerator_mods)
	SV              * class
	guint             accelerator_key
	GdkModifierType   accelerator_mods
    C_ARGS:
	accelerator_key, accelerator_mods
    CLEANUP:
	UNUSED(class);


## void gtk_accelerator_set_default_mod_mask (GdkModifierType default_mod_mask)
## call as Gtk2::Accelerator->set_default_mod_mask
void
gtk_accelerator_set_default_mod_mask (class, default_mod_mask)
	SV * class
	GdkModifierType default_mod_mask
    C_ARGS:
	default_mod_mask
    CLEANUP:
	UNUSED(class);

## guint gtk_accelerator_get_default_mod_mask (void)
## call as Gtk2::Accelerator->get_default_mod_mask
guint
gtk_accelerator_get_default_mod_mask (class)
	SV * class
    C_ARGS:
	/* void */
    CLEANUP:
	UNUSED(class);

 # no private functions
## void _gtk_accel_group_attach (GtkAccelGroup *accel_group, GObject *object)
## void _gtk_accel_group_detach (GtkAccelGroup *accel_group, GObject *object)
## void _gtk_accel_group_reconnect (GtkAccelGroup *accel_group, GQuark accel_path_quark)
 # no get_type functions
##GType gtk_accel_group_get_type (void)

##gboolean gtk_accelerator_valid (guint keyval, GdkModifierType modifiers) G_GNUC_CONST
gboolean
gtk_accelerator_valid (keyval, modifiers)
	guint           keyval
	GdkModifierType modifiers

# internal
##GtkAccelGroupEntry* gtk_accel_group_query (GtkAccelGroup *accel_group, guint accel_key, GdkModifierType accel_mods, guint *n_entries)
#void
#gtk_accel_group_query (accel_group, accel_key, accel_mods)
#	GtkAccelGroup   * accel_group
#	guint             accel_key
#	GdkModifierType   accel_mods
#    PREINIT:
#	gint                 i;
#	gint                 n_entries;
#	GtkAccelGroupEntry * entries;
#   PPCODE:
#	entries = gtk_accel_group_query(accel_group, accel_key,
#			accel_mods, &n_entries);
##	if( !entries )
#		XSRETURN_EMPTY;
#	EXTEND(SP,n_entries);
#	for( i = 0; i < n_entries; i++ )
#		PUSHs(sv_2mortal(newSVGtkAccelGroupEntry(entries[i])));
