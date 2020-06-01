
NO_TOLERANCE = 0;
3DP_TIGHT_TOLERANCE = .2;
3DP_MEDIUM_TOLERANCE = .4;
3DP_LOOSE_TOLERANCE = .6;

//LED Strip MM - Length: 1000, Width: 12, Height: 4
//Enclosure Dimensions MM - Outside -> Length: 533.4, Width: 184.15, Height: 44.45 Inner -> Length: 485.422, Width: 146.05, Height: 41.275
//Battery Dimensions MM - 350mm Length * 140mm Width * 46mm Height

ENCLOSURE_EXTERNAL_LENGTH = 513;
ENCLOSURE_EXTERNAL_WIDTH = 210;

ENCLOSURE_INTERNAL_LENGTH = 478;
ENCLOSURE_INTERNAL_WIDTH = 144.7;

ENCLOSURE_EXTERNAL_LENGTH_BETWEEN_HOLE_CENTER = 195;
ENCLOSURE_EXTERNAL_WIDTH_BETWEEN_HOLE_CENTER = 184;
ENCLOSURE_EXTERNAL_WIDTH_DISTANCE_FROM_EDGE = 13;

ENCLOSURE_LIP_THICKNESS = 6.35;

ENCLOSURE_BOLT_HOLE_DIAMETER = 4.2;

LED_HOLDER_WALLS = 2;

LED_STRIP_WIDTH = 12;
LED_STRIP_HEIGHT = 4;

LED_LENGTH = 5;
LED_WIDTH = 5;
LED_HEIGHT = 5;

module led_holder (
    hl,
    hw,
    hh,
    lc, /* width of led channel */
    debug = false, /* when enabled prints debug info*/
    mc = "aquamarine",  /* material color */
) {
    if (debug) {
        echo("");
        echo("led holder - debug");
        echo("==================");
        echo("holder length =", hl);
        echo("holder width = ", hw);
        echo("holder height = ", hh);
        echo("channel width = ", lc);
        
    }
    difference() {
        color(mc, 1.0)
            cube([hw, hl, hh], true);
        color("olive", 1.0)
            translate([-hw/2, 0, -hh/2])
            rotate([0, 225, 0]) color(mc, 1.0)
            union() {
                color(mc, 1.0)
                    cube([hw, hl+.2, hh], true);
            
                color(mc, 1.0)
                    cube([hw, hl+.2, hh], true);
             };    
    }
}

module board_mount(
    ml,  /* mount length */
    mw,  /* mount width */
    mh,   /* mount height */
    col, /* cutout length */
    cow, /* cutout width */
    debug = false /* when enabled prints debug info */
) {

    // Calculations
    coh = mh + .2;  // cutout height
    
    if (debug) {
        echo("board mount - debug");
        echo("mount length =", ml);
        echo("mount width = ", mw);
        echo("mount height = ", mh);
        echo("cutout length = ", col);
        echo("cutout width = ", cow);
        echo("cutout height = ", coh);
    }
    difference() {
        color("dodgerblue", 1.0) cube([mw, ml, mh ], true);
        cube([cow, col, coh ], true);
    }   
}

module row_of_holes(
    diameter,  /* diameter of hole */
    depth,     /* depth of hole */
    count = 1, /* number of holes to generate */
    spacing,   /* space between holes */
    debug = false /* when enabled prints debug info */
) {
    if (debug) {
        echo("row of holes - debug");
        echo("====================");
        echo("diameter =", diameter);
        echo("depth = ", depth);
        echo("count = ", count);
        echo("spacing = ", spacing);
    }

    for (i=[0:count]){
        translate([0, i*spacing, 0]) cylinder(depth, d=diameter, center=true, $fn=360);
    }
}

module torque_mount(
    bml,     /* board mount length */
    bmw,     /* board mount width */
    bmh,     /* thickness of board mount */
    col,     /* cutout length */
    cow,     /* cutout width */
    bhd,     /* diameter of hole */
    bhc = 1, /* number of holes to generate */
    bhs,     /* space between holes */
    bhw,     /* width between bolt hole rows */
    lsw,     /* width of led strip */
    lsh,     /* height of led strip */
    lscwt,   /* thickness of the led strip channels walls */
    ledl,    /* height of an LED */
    ledw,    /* width of an LED */
    3dt,     /* tolerance of 3d print */
    debug = false /* when enabled prints debug info */
){

    // calculate measurements of the channel for the led strip
    hyp = lsw + (2 * 3dt) + (2 * lscwt);  // width of the channel factoring in printer tolerance
    leg = hyp / sqrt(2);  // legs(h,w) of the isosceles right triangle formed with the above hypotenuse  
    
    lhw = leg; // led holder width
    lhl = bml; // led holder length
    lhh = leg; // height of led holder

    lhvo = (bmh / 2) + (lhh/2);              // led holder vertical offset
    lhho = (bmw - lhw) / 2; // led holder horizontal offset

    bhh = bmh + lhh + .2;     /* depth of hole */
    if (debug) {
        echo();
        echo("Torque Mount - Debug info");
        echo("=========================");
        echo("board mount length =", bml);
        echo("board mount width = ", bmw);
        echo("board mount height = ", bmh);
        echo();
        echo("cutout length = ", col);
        echo("cutout width = ", cow);
        echo("cutout height = ", cow);
        echo();
        echo("bolt hole diameter = ", bhd);
        echo("bolt hole depth = ", bhh);
        echo("bolt hole count = ", bhc);
        echo("bolt hole spacing = ", bhs);
        echo("width between bolt hole rows = ", bhw);
        echo();
        echo("width of led strip = ", lsw);
        echo("width of led height = ", lsh);
        echo();
        echo("height of led holder = ", lhh);
        echo("led holder vertical offset", lhvo);
        echo("led holder horizontal offset", lhho);
        echo("length of led holder  = ", lhl);
        echo("width of led holder  = ", lhw);
    }
    
    difference() {
        union() {
            board_mount(bml, bmw, bmh, col, cow, debug);
            translate([lhho, 0, -lhvo])
                rotate([0, 0, 180])
                led_holder(lhl, lhw, lhh, hyp, debug);
            translate([-lhho + .2, 0, -lhvo])
                led_holder(lhl, lhw, lhh, hyp, debug);
        }

        color("Chartreuse", 1.0) translate([-(bhw/2), -bhs, -lhvo]) row_of_holes(
            bhd,
            bhh,
            bhc,
            bhs,
            debug
        );

        color("Chartreuse", 1.0) translate([bhw/2, -bhs, -lhvo]) row_of_holes(
            bhd,
            bhh,
            bhc,
            bhs,
            debug
        );
    }
}

torque_mount(
    ENCLOSURE_EXTERNAL_LENGTH,
    ENCLOSURE_EXTERNAL_WIDTH,
    ENCLOSURE_LIP_THICKNESS,
    ENCLOSURE_INTERNAL_LENGTH,
    ENCLOSURE_INTERNAL_WIDTH,
    ENCLOSURE_BOLT_HOLE_DIAMETER,
    3,
    ENCLOSURE_EXTERNAL_LENGTH_BETWEEN_HOLE_CENTER,
    ENCLOSURE_EXTERNAL_WIDTH_BETWEEN_HOLE_CENTER,
    LED_STRIP_WIDTH,
    LED_HOLDER_WALLS,
    LED_STRIP_HEIGHT,
    LED_WIDTH,
    LED_LENGTH,
    3DP_LOOSE_TOLERANCE,
    true);
