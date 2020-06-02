
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
            for (i = [0 : 1 : 3]) { /*steps -1*/
                //l = length * i;
                l = length/2 + (length * i);
                echo("step:", i);
                echo("width:", (sw + i * step)/2);
                echo("length:", l);
                translate([(sw + i * step)/2, l, 0])
                    horizontal_hole_step(sw + i * step, length,  height, diameter);
            }
        }
}

RAIL_WIDTH = 22;
RAIL_HEIGHT = 12;
HOLE_DIAMETER = 4.2;

horizontal_hole_fitting(11, RAIL_HEIGHT, HOLE_DIAMETER, 2.75, 4);