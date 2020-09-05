/*
Dimension lines
===============

Draw dimension lines. Currently it is a wrapper around the code
found on:
  http://forum.openscad.org/Dimension-Parameter-labeling-for-part-diagrams-td15172.html

Modules
-------

module dim(
        p1, 
        p2, 
        txt, 
        offset=5, 
        direction=undef, 
        dx=0, 
        dy=0, 
        dz=0
);
- - - - - - - - - - - - - 
  Draw a dimension line.
  If p1 and p2 are given, a dimension line is drawn between
  these two points.
  If only p1 and one of dx, dy or dz is given, p1 is considered
  to be the center of a circle and dx, dy or dz the diameter of
  the circle. A dimension line is drawn for that circle.  
  - p1: first point of the dimension line
  - p2: second point of the dimenstion line, may be undef
  - txt: the text of the dimension line
  - offset: how far the dimension line is from the points
  - direction: alter the position of the text, can be DIM_LEFT,
               DIM_FRONT, DIM_BACK or DIM_RIGHT.
  - dx,dy,dz: Diameter of the circle if no p2 is given.
*/

DIM_LEFT=1;
DIM_FRONT=2;
DIM_BACK=3;
DIM_RIGHT=4;


//
// nothing interesting below this
//

module dim(p1, p2, txt, offset=5, direction=undef, dx=0, dy=0, dz=0) {  
  p1=p2==undef?[p1.x-dx/2,p1.y-dy/2,p1.z-dz/2]:p1;  
  p2=p2==undef?[p1.x+dx,p1.y+dy,p1.z+dz]:p2;
  
  length=norm(p1-p2);

  if (p1.x==p2.x&&p1.y!=p2.y&&p1.z==p2.z) {
    dimy(p=p1.y>p2.y?p2:p1,length=length,txt=txt,offset=offset,direction=direction);
  }
  else if (p1.x!=p2.x&&p1.y==p2.y&&p1.z==p2.z) {
    dimx(p=p1.x>p2.x?p2:p1,length=length,txt=txt,offset=offset,direction=direction);
  }
  else if (p1.x==p2.x&&p1.y==p2.y&&p1.z!=p2.z) {
    dimz(p=p1.z>p2.z?p2:p1,length=length,txt=txt,offset=offset,direction=direction);
  }
  else {
    assert(false, "Dimension is not on x, y or z axis");
  }  
}

module dimy(p,length,txt,offset,direction) {
  translate([p.x, p.y+length/2, p.z]) {
    dimension(
      l=length,
      txt=txt,
      offset2=direction==DIM_RIGHT?offset:-offset,
      dir=[0,1,0]  
    );
  }
}

module dimx(p,length,txt,offset,direction) {
  translate([p.x+length/2, p.y, p.z]) {
    dimension(
      l=length,
      txt=txt,
      offset2=direction==DIM_BACK?offset:-offset,
      dir=[1,0,0]  
    );
  }
}

module dimz(p,length,txt,offset,direction) {
  translate([p.x, p.y, p.z+length/2]) {
    dimension(
      l=length,
      txt=txt,
      offset2=direction==DIM_RIGHT?-offset:offset,
      dir=direction==DIM_FRONT?[0,0,-1]:[0,0,1],
      angle=direction==DIM_FRONT?180:90
    );
  }
}


// source: http://forum.openscad.org/Dimension-Parameter-labeling-for-part-diagrams-td15172.html

module dimension(txt, l, size=0.7, offset1=0, offset2=0, dir=[1,0,0], angle=0) {
  wText = (len(txt)+1) * size * 0.75; // 0.75 is roughly estimated character spacing
  thLine = size/10;
  arrowSize = thLine*4; // length of one side of equilateral triangle
  arrowHeight = arrowSize*sqrt(3)/2; // altitude of triangle
  hOffset = arrowSize/2 > abs(offset2) ? arrowSize : abs(offset2) + arrowSize/2;
  textOffset = offset1 == 0 ? (l - thLine < wText ? l/2+arrowHeight : 0) : sign(offset1)*l/2 + offset1;
  drawOuter = l-thLine < arrowHeight*2;
  a = -acos((dir/norm(dir))*[1,0,0]);
  vr = cross(dir,[1,1e-40,0]);
  wTextLine = abs(offset1)+wText-(drawOuter?arrowHeight:0);
  halign = (textOffset > 0) ? "left" : ((textOffset < 0) ? "right" : "center");

  rotate(angle,dir) rotate(a,vr) {
    translate([0,offset2]) linear_extrude(thLine) {
      for (i = [0:1]) mirror([i,0,0])  {
        // "vertical" lines
        translate([l/2,sign(offset2)*(arrowSize/2-hOffset/2)]) square([thLine,abs(hOffset)], center=true); 
        if (drawOuter) {
          // outer arrows
          translate([l/2+thLine/2,0]) polygon([ 
            [0,0],[arrowHeight, arrowSize/2],[arrowHeight, thLine/2],[arrowHeight*3, thLine/2],
            [arrowHeight*3, -thLine/2],[arrowHeight, -thLine/2],[arrowHeight, -arrowSize/2]
          ]);
        }
      }
      if (drawOuter) {
        // inner line
        square([l-thLine,thLine],center=true);
      } else {
        // inner arrows
        translate([-l/2+thLine/2,0]) polygon([ 
          [0,0],[arrowHeight, arrowSize/2],[arrowHeight, thLine/2],[l-thLine-arrowHeight, thLine/2],[l-thLine-arrowHeight, arrowSize/2],
          [l-thLine,0],[l-thLine-arrowHeight,-arrowSize/2],[l-thLine-arrowHeight,-thLine/2],[arrowHeight,-thLine/2],[arrowHeight,-arrowSize/2]
        ]);
      }

      if (textOffset != 0) 
        translate([sign(textOffset)*(wTextLine/2+l/2+(drawOuter? arrowHeight : 0)),0]) square([wTextLine,thLine], center=true); 

      translate([textOffset,arrowSize]) text(txt, size=size, halign=halign, valign="bottom");
    }
  }
  

}
