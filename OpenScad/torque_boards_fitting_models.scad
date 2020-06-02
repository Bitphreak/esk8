
module horizontal_hole_fitting(){
    RAIL_WIDTH = 22;
    RAIL_HEIGHT = 7;
    HOLE_DIAMETER = 4.2;
    
    difference() {
        cube([RAIL_WIDTH, 30, RAIL_HEIGHT], true);
        cylinder(RAIL_HEIGHT+.2, d=HOLE_DIAMETER, center=true, $fn=360);
    }
}

horizontal_hole_fitting();