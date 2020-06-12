
module horizontal_hole_step(
    width,
    length,
    height,
    diameter
    ){
        difference() {
            cube([width, length, height], true);
            cylinder(height + .2, d=diameter, center=true, $fn=360);
        }
}

module horizontal_hole_fitting(
    sw,       /* starting width */
    height,   /* height */
    diameter, /* diameter of hole */
    step,     /* how much to increase width for each step */
    steps     /* how many steps to take */
    ){
        length = diameter * 3;  
        union(){
            for (i = [0 : 1 : steps - 1]) {
                l = length/2 + (length * i);
                echo("step:", i);
                echo("width:", (sw + i * step)/2);
                echo("length:", l);
                translate([(sw + i * step)/2, l, 0])
                    horizontal_hole_step(sw + i * step, length,  height, diameter);
            }
        }
}

module width_gauge(
    sw,       /* starting width */
    height,   /* height */
    length, /* diameter of hole */
    step,    /* how much to increase width for each step */
    steps     /* how many steps to take */
    ){
        union(){
            for (i = [0 : 1 : steps - 1]) {
                l = length/2 + (length * i);
                echo("step: ", i, " width:", sw + i * step);
                translate([(sw + i * step)/2, l, 0])
                    cube([sw + i * step, length,  height], true);
            }
        }
}

module rounded_corner_gauge(
    sw,       /* starting width */
    height,   /* height */
    length, /* diameter of hole */
    step,    /* how much to increase width for each step */
    steps     /* how many steps to take */
    ){
        union(){
            for (i = [0 : 1 : steps - 1]) {
                l = length/2 + (length * i);
                echo("step:", i);
                echo("width:", (sw + i * step)/2);
                echo("length:", l);
                translate([(sw + i * step)/2, l, 0])
                    cube([sw + i * step, length,  height], true);
            }
        }
}

module radius_gauge(
    diameter, /* diameter of the curve */
    height   /* height of the gauge */
){
    cylinder(d = diameter, true);
}

//Left: Towards X-
//Right: Towards X+
//Front/Forward: Towards Y-
//Back/Behind: Towards Y+
//Bottom/Down/Below: Towards Z-
//Top/Up/Above: Towards Z+
//Axis-Positive: Towards the positive end of the axis the object is oriented on. IE: X+, Y+, or Z+.
//Axis-Negative: Towards the negative end of the axis the object is oriented on. IE: X-, Y-, or Z-.


module arc_quadrant(
    diameter, /* diameter of the curve */
    height,   /* height of the gauge */
    quad      /* Cartesian quadrant */
){

    // offsets for adjacent quadrant
    aq_xfactor = (quad == 2 || quad == 3) ? 1 : -1;
    aq_yfactor = (quad == 1 || quad == 2) ? 1 : -1;
    aq_dx = (diameter / 4) * aq_xfactor;
    aq_dy = (diameter / 4) * aq_yfactor;

    // offsets for adjacent half
    ah_yfactor = (quad == 3 || quad == 4) ? 1 : -1;
    ah_dy = (diameter / 4) * ah_yfactor;
    
    
    difference() {
        cylinder(h = height, d = diameter, center = true, $fn = 360);

        // mask for adjacent quadrant
        translate([aq_dx, aq_dy, 0]) cube([diameter/2, diameter/2, height + .1], center = true);
        translate([0, ah_dy, 0]) cube([diameter, diameter/2, height + .1], center = true);
    }
    //translate([0, ah_dy, 0]) cube([diameter, diameter/2, height + .1], center = true);
}

module rounded_corner(
    diameter, /* diameter of the curve */
    height,   /* height of the gauge */
    w0,
    d0,
    w1,
    d1
){
    
    // TODO: ??? change inputs to take total width & depth, rail width & depth ???
    
    corner_depth = diameter / 2;
    dy0 = corner_depth - d0 / 2;
    dx0 = w0/2;
    dx1 = corner_depth - w1 / 2;
    union() {
        arc_quadrant(diameter, height, 2);
        translate([dx0, dy0, 0]) cube([w0, d0, height], true);
        translate([-dx1, -d1/2, 0]) cube([w1, d1, height], true);
        //translate([w0, 0, 0]) arc_quadrant(diameter, height, 1);
        //translate([dx1 + w0, -d1/2, 0]) cube([w1, d1, height], true);
    }
}


RAIL_WIDTH = 22;
RAIL_HEIGHT = 8;
HOLE_DIAMETER = 4.2;

//horizontal_hole_fitting(11, RAIL_HEIGHT, HOLE_DIAMETER, 2.75, 4);
//width_gauge(5.5, RAIL_HEIGHT, 6, 2.75, 6);
//radius_gauge(25.4, RAIL_HEIGHT);
//radius_gauge(28.5, RAIL_HEIGHT);
//radius_gauge(31.75, RAIL_HEIGHT);
//radius_gauge(35, RAIL_HEIGHT);
//radius_gauge(38, RAIL_HEIGHT);
//radius_gauge(42, RAIL_HEIGHT);

rounded_corner(42, RAIL_HEIGHT, 10, 5.5, 16.5, 10);
//arc_quadrant(42, RAIL_HEIGHT, 2);


