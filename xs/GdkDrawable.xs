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
 * $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/Gtk2/xs/GdkDrawable.xs,v 1.8 2003/09/14 20:07:43 rwmcfa1 Exp $
 */

#include "gtk2perl.h"

/*
NOTE:
GdkDrawable descends directly from GObject, so be sure to use GdkDrawable_noinc
for functions that return brand-new objects!  (i don't think there are any,
but there are several functions in other modules returning GdkDrawable
subclasses)
*/

MODULE = Gtk2::Gdk::Drawable	PACKAGE = Gtk2::Gdk::Drawable	PREFIX = gdk_drawable_

 ## deprecated
 ## GdkDrawable* gdk_drawable_ref (GdkDrawable *drawable)
 ## deprecated
 ## void gdk_drawable_unref (GdkDrawable *drawable)
 ## deprecated
 ## gpointer gdk_drawable_get_data (GdkDrawable *drawable, const gchar *key)

 ## void gdk_drawable_get_size (GdkDrawable *drawable, gint *width, gint *height)
void gdk_drawable_get_size (GdkDrawable *drawable, OUTLIST gint width, OUTLIST gint height)

 ## void gdk_drawable_set_colormap (GdkDrawable *drawable, GdkColormap *colormap)
void
gdk_drawable_set_colormap (drawable, colormap)
	GdkDrawable *drawable
	GdkColormap *colormap

 ## GdkColormap* gdk_drawable_get_colormap (GdkDrawable *drawable)
GdkColormap*
gdk_drawable_get_colormap (drawable)
	GdkDrawable *drawable

 ## GdkVisual* gdk_drawable_get_visual (GdkDrawable *drawable)
GdkVisual*
gdk_drawable_get_visual (drawable)
	GdkDrawable *drawable

 ## gint gdk_drawable_get_depth (GdkDrawable *drawable)
gint
gdk_drawable_get_depth (drawable)
	GdkDrawable *drawable

#if GTK_CHECK_VERSION(2,2,0)

## GdkScreen* gdk_drawable_get_screen (GdkDrawable *drawable)
GdkScreen*
gdk_drawable_get_screen (drawable)
	GdkDrawable *drawable

## GdkDisplay* gdk_drawable_get_display (GdkDrawable *drawable)
GdkDisplay*
gdk_drawable_get_display (drawable)
	GdkDrawable *drawable

#endif

MODULE = Gtk2::Gdk::Drawable	PACKAGE = Gtk2::Gdk::Drawable	PREFIX = gdk_

 ## void gdk_draw_line (GdkDrawable *drawable, GdkGC *gc, gint x1_, gint y1_, gint x2_, gint y2_)
void
gdk_draw_line (drawable, gc, x1_, y1_, x2_, y2_)
	GdkDrawable *drawable
	GdkGC *gc
	gint x1_
	gint y1_
	gint x2_
	gint y2_

 ## void gdk_draw_rectangle (GdkDrawable *drawable, GdkGC *gc, gboolean filled, gint x, gint y, gint width, gint height)
void
gdk_draw_rectangle (drawable, gc, filled, x, y, width, height)
	GdkDrawable *drawable
	GdkGC *gc
	gboolean filled
	gint x
	gint y
	gint width
	gint height

 ## void gdk_draw_arc (GdkDrawable *drawable, GdkGC *gc, gboolean filled, gint x, gint y, gint width, gint height, gint angle1, gint angle2)
void
gdk_draw_arc (drawable, gc, filled, x, y, width, height, angle1, angle2)
	GdkDrawable *drawable
	GdkGC *gc
	gboolean filled
	gint x
	gint y
	gint width
	gint height
	gint angle1
	gint angle2

 ## void gdk_draw_polygon (GdkDrawable *drawable, GdkGC *gc, gboolean filled, GdkPoint *points, gint npoints)
void
gdk_draw_polygon (drawable, gc, filled, x1, y1, ...)
	GdkDrawable *drawable
	GdkGC *gc
	gboolean filled
	int x1
	int y1
    PREINIT:
	GdkPoint * points;
	gint npoints;
	gint i, j;
    CODE:
	UNUSED(x1);
	UNUSED(y1);
	npoints = (items-3)/2;
	points = g_new (GdkPoint, npoints);
	for (i = 0, j = 3; i < npoints ; i++, j+=2) {
		points[i].x = SvIV (ST (j));
		points[i].y = SvIV (ST (j+1));
	}
	gdk_draw_polygon (drawable, gc, filled, points, npoints);
	g_free (points);

 ## void gdk_draw_drawable (GdkDrawable *drawable, GdkGC *gc, GdkDrawable *src, gint xsrc, gint ysrc, gint xdest, gint ydest, gint width, gint height)
void
gdk_draw_drawable (drawable, gc, src, xsrc, ysrc, xdest, ydest, width, height)
	GdkDrawable *drawable
	GdkGC *gc
	GdkDrawable *src
	gint xsrc
	gint ysrc
	gint xdest
	gint ydest
	gint width
	gint height

 ## void gdk_draw_image (GdkDrawable *drawable, GdkGC *gc, GdkImage *image, gint xsrc, gint ysrc, gint xdest, gint ydest, gint width, gint height)
void
gdk_draw_image (drawable, gc, image, xsrc, ysrc, xdest, ydest, width, height)
	GdkDrawable *drawable
	GdkGC *gc
	GdkImage *image
	gint xsrc
	gint ysrc
	gint xdest
	gint ydest
	gint width
	gint height

 ## void gdk_draw_points (GdkDrawable *drawable, GdkGC *gc, GdkPoint *points, gint npoints)
 ## void gdk_draw_lines (GdkDrawable *drawable, GdkGC *gc, GdkPoint *points, gint npoints)
void
gdk_draw_points (drawable, gc, x1, y1, ...)
	GdkDrawable *drawable
	GdkGC *gc
	int x1
	int y1 
    ALIAS:
	Gtk2::Gdk::Drawable::draw_points = 1
	Gtk2::Gdk::Drawable::draw_lines  = 2
    PREINIT:
	GdkPoint * points;
	gint npoints;
	gint i, j;
    CODE:
	UNUSED(x1);
	UNUSED(y1);
	npoints = (items-2)/2;
	points = g_new (GdkPoint, npoints);
	for (i = 0, j = 2; i < npoints ; i++, j+=2) {
		points[i].x = SvIV (ST (j));
		points[i].y = SvIV (ST (j+1));
	}
	if (ix == 1)
		gdk_draw_points (drawable, gc, points, npoints);
	else
		gdk_draw_lines (drawable, gc, points, npoints);
	g_free (points);

 #### void gdk_draw_segments (GdkDrawable *drawable, GdkGC *gc, GdkSegment *segs, gint nsegs)
void
gdk_draw_segments (drawable, gc, x1, y1, x2, y2, ...)
	GdkDrawable *drawable
	GdkGC *gc
	int x1
	int y1
	int x2
	int y2
    PREINIT:
	GdkSegment * segs;
	gint nsegs;
	gint i, j;
    CODE:
	UNUSED(x1);
	UNUSED(y1);
	UNUSED(x2);
	UNUSED(y2);
	nsegs = (items-2)/4;
	segs = g_new (GdkSegment, nsegs);
	for (i = 0, j = 2; i < nsegs ; i++, j+=4) {
		segs[i].x1 = SvIV (ST (j+0));
		segs[i].y1 = SvIV (ST (j+1));
		segs[i].x2 = SvIV (ST (j+2));
		segs[i].y2 = SvIV (ST (j+3));
	}
	gdk_draw_segments (drawable, gc, segs, nsegs);
	g_free (segs);


#if GTK_CHECK_VERSION(2,2,0)

 ## void gdk_draw_pixbuf (GdkDrawable *drawable, GdkGC *gc, GdkPixbuf *pixbuf, gint src_x, gint src_y, gint dest_x, gint dest_y, gint width, gint height, GdkRgbDither dither, gint x_dither, gint y_dither)
void
gdk_draw_pixbuf (drawable, gc, pixbuf, src_x, src_y, dest_x, dest_y, width, height, dither, x_dither, y_dither)
	GdkDrawable *drawable
	GdkGC *gc
	GdkPixbuf *pixbuf
	gint src_x
	gint src_y
	gint dest_x
	gint dest_y
	gint width
	gint height
	GdkRgbDither dither
	gint x_dither
	gint y_dither

#endif

 # FIXME need typemap for PangoGlyphString
## ## void gdk_draw_glyphs (GdkDrawable *drawable, GdkGC *gc, PangoFont *font, gint x, gint y, PangoGlyphString *glyphs)
##void
##gdk_draw_glyphs (drawable, gc, font, x, y, glyphs)
##	GdkDrawable *drawable
##	GdkGC *gc
##	PangoFont *font
##	gint x
##	gint y
##	PangoGlyphString *glyphs

 # FIXME need typemap PangoLayoutLine
## ## void gdk_draw_layout_line (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, PangoLayoutLine *line)
##void
##gdk_draw_layout_line (drawable, gc, x, y, line)
##	GdkDrawable *drawable
##	GdkGC *gc
##	gint x
##	gint y
##	PangoLayoutLine *line

 ## void gdk_draw_layout (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, PangoLayout *layout)
void
gdk_draw_layout (drawable, gc, x, y, layout)
	GdkDrawable *drawable
	GdkGC *gc
	gint x
	gint y
	PangoLayout *layout

 # FIXME need typemap for PangoLayoutLine
## ## void gdk_draw_layout_line_with_colors (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, PangoLayoutLine *line, GdkColor *foreground, GdkColor *background)
##void
##gdk_draw_layout_line_with_colors (drawable, gc, x, y, line, foreground, background)
##	GdkDrawable *drawable
##	GdkGC *gc
##	gint x
##	gint y
##	PangoLayoutLine *line
##	GdkColor *foreground
##	GdkColor *background

 ## void gdk_draw_layout_with_colors (GdkDrawable *drawable, GdkGC *gc, gint x, gint y, PangoLayout *layout, GdkColor *foreground, GdkColor *background)
void
gdk_draw_layout_with_colors (drawable, gc, x, y, layout, foreground, background)
	GdkDrawable *drawable
	GdkGC *gc
	gint x
	gint y
	PangoLayout *layout
	GdkColor *foreground
	GdkColor *background

 ## GdkImage* gdk_drawable_get_image (GdkDrawable *drawable, gint x, gint y, gint width, gint height)
GdkImage*
gdk_drawable_get_image (drawable, x, y, width, height)
	GdkDrawable *drawable
	gint x
	gint y
	gint width
	gint height
