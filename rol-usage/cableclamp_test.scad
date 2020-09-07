// This work is licensed under the Creative Commons 
// Attribution-ShareAlike 4.0 International License. 
// To view a copy of this license, visit
// http://creativecommons.org/licenses/by-sa/4.0/.

//
// Test with dimensions for rol/cableclamp.scad
//

include <../rol/cableclamp.scad>
include <../rol/dimension.scad>

$fa = 5;
$fs = 0.01;  

default=cable_clamp_settings();
diameter = default[CC_IDX_DIAMETER];

// front base
cable_clamp_base(cables=3,settings=default);
base_size=cable_clamp_base_size(cables=3,settings=default);
clip_size=cable_clamp_clip_size(settings=default);
cable3=cable_clamp_base_cable(cables=3,cable=3,settings=default);

// 2 clips for the front base
for(n=[2:3]) {
  translate([
    cable_clamp_xoffset(cables=3,clip=n,settings=default),
    0,
    base_size.z + default[CC_IDX_CUTOUT]
  ]) {
    translate([0,0,clip_size.z]) mirror([0,0,1]) {
      cable_clamp_clip(settings=default);      
    }
  }
}

// cable
color("sienna") {
translate(
  cable3+[0,15,0]
) {
    rotate([90,0,0]) cylinder(d=diameter, h=20);
  }
}

// nuts and screws
for(cable=[2:3]) {
  for(hole=[1:2]) {
    point=cable_clamp_base_hole(cables=3,clip=cable,hole=hole,settings=default);
    translate([point.x, point.y, -5]) metric_nut(size=3);
    translate([point.x, point.y, 25]) metric_bolt(size=3,pitch=0);
  }
}

// dimension lines
color("red") {
  hole1=cable_clamp_base_hole(cables=3,clip=1,hole=1,settings=default);
  cable1=cable_clamp_base_cable(cables=3,cable=1,settings=default);
  dim(
    p1=[hole1.x,0,base_size.z],
    p2=[cable1.x-diameter/2,0,base_size.z],
    txt="hole_offset",
    offset=8
  );
  dim(
    p1=[cable1.x,0,base_size.z],
    dx=diameter,
    txt="diameter"
  );
  dim(
    p1=[0,0,0],
    p2=[0,base_size.y,0],
    txt="width"
  );
  dim(
    p1=hole1,
    dx=default[CC_IDX_NUT],
    txt="screw",
    d=DIM_BACK,
    offset=base_size.y/2+5
  );
  dim(
    p1=[0,base_size.y,0],
    p2=[0,base_size.y,base_size.z],
    txt="height"
  );
     
      
  offset=cable_clamp_xoffset(cables=3,clip=3,settings=default);
  gap_x=offset-default[CC_IDX_GAP];
  cutout=default[CC_IDX_CUTOUT];
  gap_z=base_size.z+clip_size.z+cutout;
  
  dim(
    p1=[gap_x,0,gap_z],
    p2=[gap_x+default[CC_IDX_GAP],0,gap_z],
    txt="gap"
  );
  
  clip_z=base_size.z+cutout;
  dim(
    p1=[offset+clip_size.x,0,clip_z],
    p2=[offset+clip_size.x,0,clip_z+clip_size.z],
    txt="clip_height",
    d=DIM_RIGHT
  );
  
  dim(
    p1=[offset+clip_size.x,0,clip_z-cutout],
    p2=[offset+clip_size.x,0,clip_z],
    txt="cutout",
    d=DIM_RIGHT,
    offset=8
  );
  
  dim(
    p1=[cable3.x,-1.5,cable3.z],
    dz=diameter,
    txt="diameter"
  );
}
  
translate([0,20,0]) {
  // second base
  cable_clamp_base(cables=4,perclip=2,settings=default);
  
  // second clip
  translate([0,0,10]) {
    clip_size=cable_clamp_clip_size(settings=default,perclip=2);
    translate([0,0,clip_size.z]) mirror([0,0,1]) {
      cable_clamp_clip(perclip=2,settings=default);
    }
  }
  
  // dimension line for spacing
  cable1=cable_clamp_base_cable(cables=4,perclip=2,cable=1,settings=default);
  cable2=cable_clamp_base_cable(cables=4,perclip=2,cable=2,settings=default);
  color("red") {
    dim(
      p1=[cable1.x+diameter/2,0,base_size.z],
      p2=[cable2.x-diameter/2,0,base_size.z],
      txt="spacing"
    );
  }
}

translate([0,40,0]) {
  // 3rd base
  cable_clamp_base(cables=3,perclip=3,settings=default);
}


