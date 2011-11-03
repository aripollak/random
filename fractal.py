#!/usr/bin/env python
# Copyright (C) 2007 Ari Pollak <ajp@aripollak.com>, 
#                    Benjamin Mako Hill <mako@atdot.cc>,
#                    and Mika Matsuzaki <mika@yukidoke.org>
# Fractal animation plugin for GIMP 2.3+ (a la the Hasselhoff animation)
# Example here: http://stuff.ebnj.net/makopainting.gif
#
# Directions for use:
#   Stick this file into ~/.gimp-2.6/plug-ins. Then start up GIMP, load the
#   image you want to modify, and use the rectangular select tool to select
#   a region to start animating from. Then go to Filters->Fractal Animation,
#   select the number of steps you want, and press OK.
#
# TODO: make the animation smoother, so it doesn't slow down towards the end of
#       each cycle
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

from __future__ import division # Always use floating-point division
import sys

try:
    import gimpfu
    import gimp
    in_gimp = True
except:
    in_gimp = False

def copier(w, h, x1, y1, x2, y2):
    """
    Variables:
        w, h:   Width & height of full image
        x1, y1: Top left corner of selection
        x2, y2: Bottom right corner of selection
    Returns:
        coordinates for images decreasing in size from the initial one,
        stopping when it can't make the image any smaller.
    """
    coords = []
    
    # compute center point
    ratio = (x2 - x1) / w

    a = x1 / (1 - ratio)
    b = y1 / (1 - ratio)

    for i in xrange(15):
        if int(x1) >= int(x2) or int(y1) >= int(y2):
            break

        new_x1 = a - (ratio * (a - x1))
        new_y1 = b - (ratio * (b - y1))

        new_x2 = a + (x2 - a) * ratio
        new_y2 = b + (y2 - b) * ratio

        coords += [((int(x1), int(y1)), (int(x2), int(y2)))]
        w, h, x1, y1, x2, y2 = x2, y2, new_x1, new_y1, new_x2, new_y2

    return coords

def copy(image, layer):
    """Create initial layer; it contains the original layer, plus 
       infinitely smaller copies of that image."""
    if gimpfu.pdb.gimp_selection_is_empty(image):
        gimp.message("Selection must not be empty")
        raise "Selection must not be empty"

    w, h = layer.width, layer.height
    x1, y1, x2, y2 = layer.mask_bounds
    gimpfu.pdb.gimp_selection_none(image)
    # Trim selection to match aspect ratio
    if (x2 - x1) / (y2 - y1) > (w / h):
        # x is too long, adjust for new x values
        newx = (w / h) * (y2 - y1)
        middle = x1 + ((x2 - x1) / 2)
        x1 = int(middle - newx / 2)
        x2 = int(middle + newx / 2)
    elif (x2 - x1) / (y2 - y1) < (w / h):
        # y is too long, adjust for new y values
        newy = (x2 - x1) / (w / h)
        middle = y1 + ((y2 - y1) / 2)
        y1 = int(middle - newy / 2)
        y2 = int(middle + newy / 2)

    cset = copier(w, h, x1, y1, x2, y2)
    for topleft, bottomright in cset:
        newlayer = layer.copy()
        image.add_layer(newlayer, 1)

        # I have no idea why this is transforming layer instead of newlayer
        layer.transform_scale(topleft[0],
                              topleft[1],
                              bottomright[0],
                              bottomright[1],
                              gimpfu.TRANSFORM_FORWARD,
                              gimpfu.INTERPOLATION_CUBIC,
                              False, # supersampling?
                              3, # level of recursion
                              gimpfu.TRANSFORM_RESIZE_ADJUST)
    
    image.merge_visible_layers(gimpfu.CLIP_TO_IMAGE)
    return cset

def shrinker(w, h, x1, y1, x2, y2, n):
    """
    Variables:
        w: width of the image/layer
        h: height of the image/layer
        x1, y1, x2, y2: upper-left and bottom-right coordinates of
          target image
        n: the number of steps you want to the shrinker to use
    Returns:
        an n-item array of 2-item tuples containing the top-left and
        bottom-right coordinates of a rectatangle at n-stages of shrinkage.
        The last item is a point.
    """

    result = []
    # initialize our list with image size
    for i in xrange(1, n):
        c1 = (int(i * x1 / n), int(i * y1 / n)) #left, top
        c2 = (int(w - (((w - x2) * i) / n)),
              int(h - (((h - y2) * i) / n))) # bottom, right
        result += [(c1, c2)]

    return result

def shrink(image, layer, cset, frames, has_alpha):
    """Create new layers for slowly shrinking copies of the original image,
       until it gets to the original """
    #print cset
    x1, y1, x2, y2 = cset[0][0][0], cset[0][0][1], cset[0][1][0], cset[0][1][1]
    for topleft, bottomright in shrinker(image.width, image.height,
                                         x1, y1, x2, y2, frames):
        newlayer = layer.copy()
        image.add_layer(newlayer, len(image.layers))

        #print topleft, bottomright
        newlayer.transform_scale(topleft[0],
                              topleft[1],
                              bottomright[0],
                              bottomright[1],
                              gimpfu.TRANSFORM_FORWARD,
                              gimpfu.INTERPOLATION_CUBIC,
                              False, # supersampling?
                              3, # level of recursion
                              gimpfu.TRANSFORM_RESIZE_ADJUST)
    if has_alpha:
        # Resize to second sub-image; newh, newh, offx, offy
        image.resize(cset[1][1][0] - cset[1][0][0],
                     cset[1][1][1] - cset[1][0][1],
                     -cset[1][0][0], -cset[1][0][1])
    else:
        # No transparency, so resize to first sub-image
        image.resize(x2 - x1, y2 - y1, -x1, -y1)

    for l in image.layers:
        l.resize_to_image_size()

def fractal(image, layer, frames):
    # TODO: copy layer into new image, fit canvas to layers, and make animation
    # from there
    image.undo_group_start()
    try:
        has_alpha = layer.has_alpha
        cset = copy(image, layer)
        layer = image.layers[0]
        shrink(image, layer, cset, frames, has_alpha)
    finally:
        image.undo_group_end()

def testalgo():
    print "copier(400, 600, 0, 0, 200, 300):"
    for cset in copier(400, 600, 0, 0, 200, 300):
        print cset

    print "copier(833, 1168, 216, 324, 543, 783):"
    for cset in copier(833, 1168, 216, 324, 543, 783):
        print cset

if in_gimp:
    gimpfu.register(
            "python-fu-fractal", # name
            "Make an image into an animated fractal", # blurb
            "Make an image into an animated fractal", # help
            "Ari Pollak, Benjamin Mako Hill, and Mika Matsuzaki", # author
            "Ari Pollak, Benjamin Mako Hill, and Mika Matsuzaki", # copyright
            "2007", # date
            "<Image>/Filters/Fractal Animation", # menupath
            "RGB*, GRAY*", # imagetypes
            [
                (gimpfu.PF_SPINNER, "frames", "# of frames", 10, (1, 30, 1))
            ], # params
            [], # results
            fractal # callback
            )
    gimpfu.main()
else:
    testalgo()
