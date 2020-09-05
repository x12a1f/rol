// This work is licensed under the Creative Commons 
// Attribution-ShareAlike 4.0 International License. 
// To view a copy of this license, visit
// http://creativecommons.org/licenses/by-sa/4.0/.

//
// Usage example for rol/cableclamp.scad
//
// Creates a cable clamp for 4 cables and 4 clips 
// and adds mounting holes.
//

include <../rol/cableclamp.scad>

$fa = 5;
$fs = 0.01;  

zfix=0.01;

//
// set the default cable clamp dimensions
//

cable_clamp_default=cable_clamp_settings(
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
);


//
// draw the cable clamp base
//

cable_clamp_base(perclip=1,length=100,cables=4);


//
// draw the mounting tabs
//

base = cable_clamp_base_size(perclip=1,length=100,cables=4);
tab=[7,7,2];

for(pos = [ 
    [0           , -tab.y, 0], 
    [base.x-tab.x, -tab.y, 0],
    [0           , base.y, 0],
    [base.x-tab.x, base.y, 0],
]) {
  translate(pos) {
    difference() {
      cube(tab);
      translate([tab.x/2,tab.y/2,-zfix]) {
        cylinder(d=3.1,h=tab.z+2*zfix);
      }
    }
  }
}


//
// draw the clips
//

clip=cable_clamp_clip_size(perclip=1);
for(i=[0:3]) {
  translate([i*(clip.x+5),20,0]) {
    
    cable_clamp_clip(perclip=1);
    
  }
}