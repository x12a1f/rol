// This work is licensed under the Creative Commons 
// Attribution-ShareAlike 4.0 International License. 
// To view a copy of this license, visit
// http://creativecommons.org/licenses/by-sa/4.0/.

/**
# Cable Clamps

Cable clamps of various sizes.

These cable clamps need to be integrated with other objects as
the cable clamp do not have any way of mounting them.

See the basic usage example for a version with mounting holes.

![cable clamps](img/cableclamp_example.jpg)

## Requires:

- BOSL: https://github.com/revarbat/BOSL

## See also:

![cable clamps](img/cableclamp_usage.png)

Basic usage example: [cableclamp_usage.scad](../rol-usage/cableclamp_usage.scad)

![dimensions from cableclamp_test.scad](img/cableclamp_test.png)

More elaborate test and dimensions: [cableclamp_test.scad](../rol-usage/cableclamp_test.scad)

## Global variables

### cable_clamp_default

The default settings for the cable clamps. See [`cable_clamp_settings()`](#cable_clamp_settings) and
[changing the cable clamp dimensions](#changing-the-cable-clamp-dimensions) for more information.


## Main modules/functions

### cable_clamp_settings

Return a vector with settings for the cable clamps. Pass this vector to all 
other modules/functions.

    function cable_clamp_settings(
      width=7,
      height=6,
      diameter=7,
      cutout=1,
      hole_offset=3,
      nut=3,
      clearance=0.1,
      min_meat=0.5,
      clip_height=3.5,
      spacing=2,
      gap=1
    );
    
See [changing the cable clamp dimensions](#changing-the-cable-clamp-dimensions) for more information
about each argument.
  
  
### cable_clamp_base

Models the base of the cable clamp.

    module cable_clamp_base(
            length,
            cables,
            perclip=1,
            settings=cable_clamp_default
    );

argument | description 
---------|------------
length   | The length of the cable clamp. Leave undef to automatically determine the length based on the number of cables.
cables   | The number of cables for this clamp.
perclip  | Number of cables per clip.
settings | All dimensions for the cable clamp.  


### cable_clamp_clip

Models a single cable clip.

    module cable_clamp_clip(
            perclip=1,
            settings=cable_clamp_default
    );

argument | description
---------|------------
perclip  | Number of cables per clip.
settings | All dimensions for the cable clamp.


## Helper modules/functions

These modules/functions are useful to get the position and lengths of various parts of the
clamps. These can be useful to retrieve the exact dimensions when integrating the 
cable clamps with other parts.

These modules/functions are used for example in cableclamp_test.scad to position the 
various parts.

### cable_clamp_base_hole

Returns the position of the center of a mounting hole for the clips.

    function cable_clamp_base_hole(
            length,
            cables,
            hole=1,
            clip=1,
            perclip=1,
            settings=cable_clamp_default
    );

argument | description
---------|------------
length   | The length of the cable clamp. Leave undef to automatically determine the length based on the number of cables.
cables   | The number of cables for this clamp.
hole     | Which hole for a single clip to return. 1 (left hole) or 2 (right hole)
clip     | The number of the clip. First clip is 1.
perclip  | Number of cables per clip.
settings | All dimensions for the cable clamp.

Returns: `[x, y, z]`
   
   
### cable_clamp_base_cable

Returns the position of the center of cable.

    function cable_clamp_base_cable(
            length,
            cables,
            cable=1,
            perclip=1,
            settings=cable_clamp_default
    );

argument | description 
---------|------------
length   | The length of the cable clamp. Leave undef to automatically determine the length based on the number of cables.
cables   | The number of cables for this clamp.
cable    | The number of the cable. 1 is the first(left) cable.
perclip  | Number of cables per clip.
settings | All dimensions for the cable clamp.
   
Returns: `[x, y, z]`


### cable_clamp_base_size

Returns the size of the cable clamp base.

    function cable_clamp_base_size(
            length,
            cables,
            perclip=1,
            settings=cable_clamp_default
    );

argument | description
---------|------------
length   | The length of the cable clamp. Leave undef to automatically determine the length based on the number of cables.
cables   | The number of cables for this clamp.
perclip  | Number of cables per clip.
settings | All dimensions for the cable clamp.

Returns: `[length, width, height]`


### cable_clamp_clip_hole

Returns the position of the center of the mounting hole of the clip.

    function cable_clamp_clip_hole(
                hole=1,
                perclip=1,
                settings=cable_clamp_default
    );

argument | description
---------|------------
hole     | The number of the hole. 1 is the left hole, 2 is the right hole.
perclip  | Number of cables per clip.
settings | All dimensions for the cable clamp.

Returns: `[x, y, z]`
    
    
### cable_clamp_clip_cable

Returns the position of the center of the cable.

    function cable_clamp_clip_cable(
            perclip=1,
            cable=1,
            settings=cable_clamp_default
    );

argument | description
---------|------------
cable    | The number of the cable. The left most cable is 1.
perclip  | Number of cables per clip.
settings | All dimensions for the cable clamp.
    
Returns: `[x, y, z]`
    
    
### cable_clamp_clip_size

Returns the size of the cable clamp clip.

    function cable_clamp_clip_size(
              perclip=1,
              settings=cable_clamp_default
    );

argument | description
---------|------------
perclip  | Number of cables per clip.
settings | All dimensions for the cable clamp.
    
Returns: `[length, width, height]`


### cable_clamp_xoffset

Returns the offset on the X-axis to line up a cable clip to a cable clamp.

    function cable_clamp_xoffset(
              cables,
              length,
              clip,
              perclip=1,
              settings=cable_clamp_default
    );
  
argument | description
---------|------------
length   | The length of the cable clamp. Leave undef to automatically determine the length based on the number of cables.
cables   | The number of cables for this clamp.
clip     | The number of the clip. 1 is the left most clip.
perclip  | Number of cables per clip.
settings | All dimensions for the cable clamp.
  
  
## Changing the cable clamp dimensions

To use your own dimensions, use the `cable_clamp_settings` function to
create a vector with the settings and pass this vector as the `settings`
argument to all other functions/modules.

For more details about the dimensions, render the cableclamp_test.scad or see 
the "drawings" and examples below.

```
single clamp
       hole_offset
 hole_offset   |   diameter
         |<->|<->|<->|                         
     ___ _______________            
      ^ |        |||||         
width | |    O   =====  O    
     _v_|________|||||__ 
             |     |
             |<-f->|

                 diameter    gap
                     |<->| >||<
            _v___  _________  _________
 clip_height | i_ |   ___   ||   ___   |  _______________
            _|___ |__/   \__||__/   \__|  __v_         ^
      _v_____^___  __     ______     ___  __|_ cutout  |diameter
 height|          |  \___/      \___/     __^__v_______v_
      _|_________ |_____________________  _____|_ b
       ^               |          |            ^
                       |<-------->|
                       single_length
                       
double clamp                       
                       
  diameter    spacing  gap
        |<->|<>|     >||<
      ________________  _________
     |   ___    ___   ||   ___
     |__/   \__/   \__||__/   \__
      __     __     ______     __
     |  \___/  \___/      \___/
     |____________________________
     |    |                 |
          |<--------------->|
             single_length
  
      hole_offset  diameter
hole_offset    |    |   spacing
        |<-->|<-->|<->|<>|
         _______________________________
        |         |||||  |||||          |||  
        |    O    |||||  |||||   O   O  |||  
        |_________|||||__|||||_________ |||__

```
                          
**/

function cable_clamp_settings(
  width=7,
  height=6,
  diameter=7,
  cutout=1,
  hole_offset=3.5,
  screw=3,
  clearance=0.1,
  min_meat=0.5,
  clip_height=4,
  spacing=2,
  gap=1
) =
  [width, height, diameter, cutout, hole_offset, screw, clearance, min_meat, clip_height, spacing, gap];

// default settings  
cable_clamp_default = cable_clamp_settings();  


//
// nothing interesting below this...
//

include <BOSL/metric_screws.scad>

// smidgens to fix z-fighting
s=0.01;
ss=2*s;

// indexes into the settings
CC_IDX_WIDTH = 0;
CC_IDX_HEIGHT = 1;
CC_IDX_DIAMETER = 2;
CC_IDX_CUTOUT = 3;
CC_IDX_HOLE_OFFSET = 4;
CC_IDX_NUT = 5;
CC_IDX_CLEARANCE = 6;
CC_IDX_MIN_MEAT = 7;
CC_IDX_CLIP_HEIGHT = 8;
CC_IDX_SPACING = 9;
CC_IDX_GAP = 10;


function cable_clamp_base_hole(
        length,
        cables,
        hole=1,
        clip=1,
        perclip=1,
        settings=cable_clamp_default
) =
  let(base_length=_cc_single_base_length(perclip=perclip,settings=settings,cables=cables,length=length))
  let(clip_length=_cc_clip_length_no_gap(perclip=perclip,settings=settings))
  let(hole_offset=settings[CC_IDX_HOLE_OFFSET])
  let(offset=(base_length-clip_length)/2)
  [
    offset+(clip-1)*base_length+(hole==1?hole_offset:clip_length-hole_offset),
    settings[CC_IDX_WIDTH]/2,
    settings[CC_IDX_HEIGHT]
  ];

function cable_clamp_base_cable(
        length,
        cables,
        cable=1,
        perclip=1,
        settings=cable_clamp_default
) =
  let(hole_offset=settings[CC_IDX_HOLE_OFFSET])  
  let(diameter=settings[CC_IDX_DIAMETER])
  let(whole_clips=floor((cable-1)/perclip))
  let(remainder=(cable-1)%perclip)
  let(spacing=settings[CC_IDX_SPACING])
  let(clip_length=_cc_clip_length_no_gap(perclip=perclip,settings=settings))
  let(base_length=_cc_single_base_length(perclip=perclip,settings=settings,cables=cables,length=length))
  let(offset=(base_length-clip_length)/2)
  [
    offset+hole_offset*2+diameter/2+whole_clips*base_length+remainder*(spacing+diameter),
    settings[CC_IDX_WIDTH]/2,
    settings[CC_IDX_HEIGHT]+settings[CC_IDX_CUTOUT]/2
  ];
  
function _cc_clip_length_no_gap(perclip,settings) =
  let(hole_offset=settings[CC_IDX_HOLE_OFFSET])  
  let(diameter=settings[CC_IDX_DIAMETER])
  let(spacing=settings[CC_IDX_SPACING])
  hole_offset*4+diameter+(perclip-1)*(spacing+diameter);

function _cc_single_base_length(length,cables,perclip,settings) =
  let(hole_offset=settings[CC_IDX_HOLE_OFFSET])  
  let(diameter=settings[CC_IDX_DIAMETER])
  let(spacing=settings[CC_IDX_SPACING])
  length==undef?hole_offset*4+diameter+(perclip-1)*(spacing+diameter):length/(cables/perclip);
  
function _cc_min_length(cables,perclip,settings) =
  let(hole_offset=settings[CC_IDX_HOLE_OFFSET])
  let(diameter=settings[CC_IDX_DIAMETER])
  let(repeat=cables/perclip)
  let(spacing=settings[CC_IDX_SPACING])
  repeat * (hole_offset*4 + perclip*diameter + (perclip-1)*spacing);
  
function cable_clamp_base_size(
        length,
        cables,
        perclip=1,
        settings=cable_clamp_default
) = 
  let(height=settings[CC_IDX_HEIGHT])
  let(diameter=settings[CC_IDX_DIAMETER])
  let(hole_offset=settings[CC_IDX_HOLE_OFFSET])
  let(spacing=settings[CC_IDX_SPACING])
  assert(cables % perclip == 0, "Cables must be a multiple of perclip")
  assert(height > diameter/2, "Height must be larger than 1/2 of the cable diameter.")
  let(repeat=cables/perclip)
  let(min_length=_cc_min_length(cables=cables,perclip=perclip,settings=settings))
  let(the_length=length==undef?min_length:length)
  assert(the_length >= min_length, "Too many cables for the given length.")
  let(nut=settings[CC_IDX_NUT])
  let(min_meat=settings[CC_IDX_MIN_MEAT])
  assert(get_metric_nut_thickness(nut) < height - min_meat, "The height is not enough for the selected nut size.")  
  assert(hole_offset > nut/2 + min_meat, "hole_offset is not big enough")
  [
    the_length,
    settings[CC_IDX_WIDTH],
    height
  ];
  
  
  
module cable_clamp_base(
        length,
        cables,
        perclip=1,
        settings=cable_clamp_default
) {  
  hole_offset=settings[CC_IDX_HOLE_OFFSET];
  nut=settings[CC_IDX_NUT];
  clearance=settings[CC_IDX_CLEARANCE];
  diameter=settings[CC_IDX_DIAMETER];
  
  size=cable_clamp_base_size(
    length=length, 
    cables=cables, 
    perclip=perclip,
    settings=settings
  );
  
  difference() {
        // cable clamp
    color("tan") {     
      cube(size);
    }            
        
    // cable clamps
    for(i=[1:cables]) {
      cable=cable_clamp_base_cable(
        length=length,
        cables=cables,
        settings=settings,
        perclip=perclip,
        cable=i
      );

      // cable holes
      translate([cable.x,-s,cable.z]) { //[center_x,-s,cable_z]) {
        rotate([-90,0,0]) cylinder(d=diameter,h=size.y+ss);
      }
    }
    
    for(i=[1:perclip:cables]) {      
      // mounting holes for the clips
      for(j=[1:2]) {
        mount=cable_clamp_base_hole(
          length=length,
          cables=cables,
          settings=settings,
          perclip=perclip,
          clip=(i-1)/perclip+1,
          hole=j
        );
      
        // mounting screw
        translate([mount.x,mount.y,-s]) {        
          cylinder(d=nut+clearance,h=size.z+ss);
        }
        
        // nut
        translate([mount.x,mount.y,-s]) {
          metric_nut(size=nut+clearance,hole=false);        
        }
      }
    }
  }
  
  // cable clamp ridges
  ridge=diameter/10;
  color("tan") {
    for(i=[1:cables]) {  
      cable=cable_clamp_base_cable(
        length=length,
        cables=cables,
        settings=settings,
        perclip=perclip,
        cable=i
      );

      translate([cable.x-diameter/2, cable.y, cable.z-diameter/2]) {
        rotate([0,90,0]) cylinder(r=ridge,h=diameter);
      }
    }
  }
}

function cable_clamp_clip_hole(
            hole=1,
            perclip=1,
            settings=cable_clamp_default
) =
  let(clip_length=_cc_clip_length_no_gap(perclip=perclip,settings=settings))
  let(hole_offset=settings[CC_IDX_HOLE_OFFSET])
  let(gap=settings[CC_IDX_GAP])
  [
    (hole==1?hole_offset:clip_length-hole_offset)-gap/2,
    settings[CC_IDX_WIDTH]/2,
    settings[CC_IDX_HEIGHT]
  ];

function cable_clamp_clip_cable(
        perclip=1,
        cable=1,
        settings=cable_clamp_default
) =
  let(gap=settings[CC_IDX_GAP])
  let(hole_offset=settings[CC_IDX_HOLE_OFFSET])  
  let(diameter=settings[CC_IDX_DIAMETER])
  let(whole_clips=floor((cable-1)/perclip))
  let(remainder=cable%perclip)
  let(spacing=settings[CC_IDX_SPACING])
  let(clip_length=_cc_clip_length_no_gap(perclip=perclip,settings=settings))
  [
    hole_offset*2+diameter/2+whole_clips*clip_length+remainder*(spacing+diameter)-gap/2,
    settings[CC_IDX_WIDTH]/2,
    settings[CC_IDX_CLIP_HEIGHT]+settings[CC_IDX_CUTOUT]/2
  ];



function cable_clamp_clip_size(
          perclip=1,
          settings=cable_clamp_default
) = 
  let(min_length=_cc_min_length(cables=perclip,perclip=perclip,settings=settings))
  let(gap=settings[CC_IDX_GAP])
  let(diameter=settings[CC_IDX_DIAMETER])
  let(cut_out=settings[CC_IDX_CUTOUT])
  let(clip_height=settings[CC_IDX_CLIP_HEIGHT])
  assert(clip_height > diameter/2 - cut_out/2 + settings[CC_IDX_MIN_MEAT], "Clip heigth is too small.")
  [
    min_length-gap,
    settings[CC_IDX_WIDTH],
    clip_height    
  ];

module cable_clamp_clip(
        perclip=1,
        settings=cable_clamp_default
) {
  diameter=settings[CC_IDX_DIAMETER];
  nut=settings[CC_IDX_NUT];
  clearance=settings[CC_IDX_CLEARANCE];
  
  difference() {
    size=cable_clamp_clip_size(settings=settings,perclip=perclip);
    color("olive") {     
      cube(size);
    }            
    
    for(i=[1:perclip]) {
      cable=cable_clamp_clip_cable(settings=settings,cable=i,perclip=perclip);
      // cable hole    
      translate([cable.x,-s,cable.z]) {
        rotate([-90,0,0]) cylinder(d=diameter,h=size.y+ss);
      }
    }
    
    // mounting screws
    for(i=[1:2]) {
      position=cable_clamp_clip_hole(settings=settings,hole=i,perclip=perclip);
      translate([position.x,position.y,-s]) {
        cylinder(d=nut+clearance,h=size.z+ss);
      }
    }
    
  }
  
  // cable clamp ridges
  color("olive") {        
    ridge=diameter/10;
    for(i=[1:perclip]) {
      cable=cable_clamp_clip_cable(settings=settings,cable=i,perclip=perclip);
      translate([cable.x-diameter/2,cable.y+ridge*2,cable.z-diameter/2]) {
        rotate([0,90,0]) cylinder(r=ridge,h=diameter);
      }
      translate([cable.x-diameter/2,cable.y-ridge*2,cable.z-diameter/2]) {
        rotate([0,90,0]) cylinder(r=ridge,h=diameter);
      }
    }
  }
}

function cable_clamp_xoffset(
  cables,
  length,
  clip,
  perclip=1,
  settings=cable_clamp_default
) =
  let(cliphole=cable_clamp_clip_hole(perclip=perclip,settings=settings))
  let(basehole=cable_clamp_base_hole(perclip=perclip,cables=cables,length=length,clip=clip,settings=settings))
  basehole.x - cliphole.x;