// This work is licensed under the Creative Commons 
// Attribution-ShareAlike 4.0 International License. 
// To view a copy of this license, visit
// http://creativecommons.org/licenses/by-sa/4.0/.

//
// EXAMPLE
//
// If you set part to 'example' and have the relevant libraries installed,
// an example power strip with holders and dimension lines is rendered.
// This is not supported on the thingiverse customizer.
//

// which side
part="both"; // [blind:The side without cable,cable:The side with cable,both:Both sides]

// width of the power strip
width=55;

// height of the power strip
height=41;

// overhang
overhang=9;

// wall thickness
wall=2;

// length of the feet
length=25;

// width of the feet
base=10;

// diameter of the hole for the cable
cable=32;

// offset of the cable hole from the bottom
cable_center=20;

// size of the screw holes
screw=4.2;

// show the example


use <BOSL/shapes.scad>
include <../rol/dimension.scad>

/* [Hidden] */
$fn=0;
$fa=0.01;
$fs=0.5;

//
// example
//

if (part == "blind") {
  holder(
    width=width,
    height=height,
    overhang=overhang,
    wall=wall,
    length=length,
    base=base,
    cable=undef,
    screw=screw
  );
}
else if (part == "cable") {
  holder(
    width=width,
    height=height,
    overhang=overhang,
    wall=wall,
    length=length,
    base=base,
    cable=cable,
    cable_center=cable_center,
    screw=screw
  );
}  
else if (part == "both") {
  translate([0,0,length]) {
    rotate([0,90,0]) {
      holder(
        width=width,
        height=height,
        overhang=overhang,
        wall=wall,
        length=length,
        base=base,
        cable=undef,
        screw=screw
      );
    }
  }
  
  translate([height+10,0,length]) {
    rotate([0,90,0]) {
      holder(
        width=width,
        height=height,
        overhang=overhang,
        wall=wall,
        length=length,
        base=base,
        cable=cable,
        cable_center=cable_center,
        screw=screw
      );
    }
  }
}
else if (part == "example") {  
  // two holders to hold a typical power strip
  translate([-54,0,0]) {
    rotate([0,0,180]) {
      holder();
    }
  }
  translate([54,0,0]) {
    holder(cable=32);
  }

  // power strip
  powerstrip();

  // dimensions
  dimensions();
}

/**
# Power strip holder.

Most readily available power strips do not have any way of mounting them.
These are holders to mount a power strip onto something.

![example](img/powerstripholder_example.png)

# See also:

* [Thingiverse](https://www.thingiverse.com/thing:4590509)
* Code: [powerstripholder.scad](../parts/powerstripholder.scad)

# Requires

- BOSL: https://github.com/revarbat/BOSL (only used to render the power 
  strip in the example)
- dimensions.scad: to draw the dimensions (not needed for the actual holders)

# Arguments

- `width`: The width of the power strip (make sure its a bit oversize)
- `height`: The height of the power strip (make sure its a bit oversize)
- `overhang`: The size of the lip on top which keeps the power strip in place.
- `wall`: Wall thickness. 2mm seems to be fine.
- `length`: The length of the feet.
- `base`: The width of the feet.
- `cable`: The diameter of the cable hole or undef for no hole.
- `cable_center`: The center of the cable.
- `screw`: The size of the screw holes.

![dimensions](img/powerstripholder_dimensions.png)

**/
module holder(
  width=55,
  height=41,
  overhang=9,
  wall=2,
  length=25,
  base=10,
  cable=undef,
  cable_center=20,
  screw=4.2
) {  
  zfix=0.01;
  w=width + 2*wall;
  h=height + wall;
  l=overhang + wall;

  difference() {
    translate([0,w/2,0]) rotate([90,0,0]) linear_extrude(w) {
      polygon([ 
        [0,0],
        [length,0],
        [length,h],
        [length-overhang,h],
        [0,wall+base]
      ]);
    }
    
    translate([-zfix,-width/2,-zfix]) {
      cube([length-wall+zfix,width,height+zfix]);
    }

    if (cable != undef) {
      translate([length-zfix-wall,0,cable_center]) rotate([0,90,0]) {
        cylinder(r=cable/2,h=wall+2*zfix);
      }
      translate([length-zfix-wall,-cable/2,-zfix]) {
        cube([wall+2*zfix,cable, cable_center+zfix]);
      }    
    }    
  }

  module feet(mirror=false) {
    difference() {
      translate([mirror?length:0,0,0]) {
        rotate([90,0,mirror?270:90]) {
          linear_extrude(length) {
            polygon([
              [0,0], 
              [base,0],  
              [base, wall],
              [0, base+wall]
            ]);
          }
        }
      }
      
      translate([wall,mirror?-base+zfix:-zfix,wall]) {
        cube([length-wall*2,base+zfix,base]);  
      }

      // screw hole    
      translate([(length)/2,mirror? -base/2 : base/2,-zfix]) {
        cylinder(d=screw,h=wall+2*zfix);
      }
    }
  }

  translate([0,w/2,0]) feet();
  translate([0,-w/2,0]) feet(true);
}


//
// modules below are for testing/visualization only!
//

/*
Render the dimensions used by holder()
*/
module dimensions() {
  dim(p1=[-79+9,-55/2,41], p2=[-79+9,55/2,41], txt="width",offset=10,size=3,d=DIM_UP);
  dim(p1=[-79+9,-55/2,0], p2=[-79+9,-55/2,41], txt="height",offset=25,size=3,d=DIM_RIGHT);
  dim(p1=[-79,58/2,43], p2=[-79+9,58/2,43], txt="overhang",size=3,d=DIM_BACK);
  dim(p1=[-79,-58/2-10,0], p2=[-79+25,-58/2-10,0], txt="length",size=3,offset=10);
  dim(p1=[-79,-58/2-10,0], p2=[-79,-58/2,0], txt="base",size=3);
  dim(p1=[80,32/2,20], p2=[80,-32/2,20], txt="cable", size=3, offset=30,d=DIM_UP);
  dim(p1=[90,0,0], p2=[90,0,20], txt="cable_center", size=3,offset=40);
}


/*
Render a powerstrip for visualisation purposes only.

Uses code from https://www.thingiverse.com/thing:2251788
*/
module powerstrip() {    
  translate([0,0,20]) {
    color("WhiteSmoke")  {    
      difference() {
        rounded_prismoid(size1=[152,53],size2=[144,44],h=20,r=5);
        for(x=[-44,0,44]) {
          translate([x,0,20]) rotate([0,180,45]) {
            cylinder(r=39/2, h=18.5);
            translate([0,10,0])
                cylinder(r=7/2,h=30);
            translate([0,-10,0])
                cylinder(r=7/2,h=30);
          }
        }
      }
    }
    
    for(x=[-44,0,44]) {
      translate([x,0,0]) {
        rotate([0,0,45]) {
          color("WhiteSmoke") {
            translate([5.4/2,16.9,3]) cube([7,3,14]);        
            translate([-5.4/2-7,16.9,3]) cube([7,3,14]);
            translate([5.4/2,-20.4,3]) cube([7,3.5,14]);
            translate([-5.4/2-7,-20.4,3]) cube([7,3.5,14]);
          }
          color("Goldenrod") {
            translate([-21,-1.5,0]) cube([4,3,17]);           
            rotate([0,0,180]) {
              translate([-21,-1.5,0]) cube([4,3,17]);          
            }
          }
        }
      }
    }
  }
  
  color("WhiteSmoke") {
    rounded_prismoid(size1=[144,44],size2=[152,53],h=20,r=5);
    translate([70,0,20]) rotate([0,90,0]) cylinder(d=30,h=9);
    translate([81,0,20]) rotate([0,90,0]) cyl(d1=30,d2=15,h=4);
    translate([81,0,20]) rotate([0,90,0]) cylinder(d=6,h=40);
  }

  translate([-74,-24,20]) color("Black") cube([146,46,1]);  
}
