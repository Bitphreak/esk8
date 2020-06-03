
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
radius_gauge(42, RAIL_HEIGHT);