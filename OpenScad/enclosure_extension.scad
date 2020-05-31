
NO_TOLERANCE = 0;
3DP_TIGHT_TOLERANCE = .2;
3DP_MEDIUM_TOLERANCE = .4;

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

RAIL_HEIGHT = 12.7;

CASE_THICKNESS = 2.51;
CASE_LIP_WIDTH = 12.7;

LED_BAR_LENGTH = ENCLOSURE_EXTERNAL_LENGTH;
LED_BAR_WIDTH = 12;
LED_BAR_HEIGHT = 4;

LED_HOLDER_WALLS = 2;

LED_HOLDER_LENGTH = LED_BAR_LENGTH;
LED_HOLDER_WIDTH = LED_BAR_WIDTH + LED_HOLDER_WALLS;
LED_HOLDER_HEIGHT = LED_BAR_HEIGHT + LED_HOLDER_WALLS;

ENCLOSURE_HEIGHT = 44.45;

LED_LENGTH = 5;
LED_WIDTH = 5;
LED_HEIGHT = 5;

module negative(
    l,  /* length of the holder */
    w,  /* width of the holder  */
    h,  /* height of the holder */
    ll, /* length of the led strip */
    lw, /* width of the led strip  */
    lh, /* height of the led strip */
    lt = 3DP_MEDIUM_TOLERANCE, /* length tolerance of the led strip */
    wt = 3DP_MEDIUM_TOLERANCE, /* width tolerance of the led strip  */
    ht = 3DP_MEDIUM_TOLERANCE, /* height tolerance of the led strip */
    negative = false  /* ht - height tolerance of the led strip */
    ) {
        dh = w/2 * sqrt(2);
        
        top = dh/2;
        offset = lh/2 + top + .1;

        echo("l = ", l);
        echo("lt = ", lt);
        union() {
            color("aquamarine", 1.0) cube([dh + (2 * wt), l + (2 * lt), dh + ht], true);
            /*translate([0, 0, -offset])*/ color("midnightblue", 1.0) cube([lw + (2 * wt), l + (2 * lt), lh + ht], true);
        }    
}
        
/**
*/
module rail(
    l,  /* l - length of the rail */
    w,  /* w - width of the rail  */
    h,  /* h - height of the rail */
    hl,  /* l - length of the holder */
    hw,  /* w - width of the holder  */
    hh,  /* h - height of the led strip */
    ll, /* l - length of the led strip */
    lw, /* w - width of the led strip  */
    lh, /* h - height of the led strip */
    lt = 3DP_MEDIUM_TOLERANCE, /* lt - length tolerance of the led strip */
    wt = 3DP_MEDIUM_TOLERANCE, /* wt - width tolerance of the led strip  */
    ht = 3DP_MEDIUM_TOLERANCE  /* ht - height tolerance of the led strip */
    ) {
    dh = hw/2 * sqrt(2);
    
    difference() {
            color("dodgerblue", 1.0) cube([dh*2+4.45, l, dh+4], true);
            translate([-dh, 0, -dh/2]) rotate([0, 225, 0]) color("aquamarine", 1.0) negative(hl, hw, hh, ll, lw, lh, lt, wt, ht);
            translate([CASE_LIP_WIDTH/2-.5, 0, 0]) cube([CASE_LIP_WIDTH, l+.2, CASE_THICKNESS], true);
    }
}

//negative(PROTO_LED_HOLDER_LENGTH, PROTO_LED_HOLDER_WIDTH, PROTO_LED_HOLDER_HEIGHT, PROTO_LED_BAR_LENGTH, PROTO_LED_BAR_WIDTH, PROTO_LED_BAR_HEIGHT);


module mount(
    el, /* external length of the mount */
    ew, /* external width of the mount  */
    il, /* internal length of the mount */
    iw, /* internal width of the mount */
    ct /* case thickness */
    
//    eh, /* height of the rail */
//    hl, /* length of the holder */
//    hw, /* width of the holder  */
//    hh, /* height of the led strip */
//    ll, /* length of the led strip */
//    lw, /* width of the led strip  */
//    lh, /* height of the led strip */
//    lt = 3DP_MEDIUM_TOLERANCE, /* lt - length tolerance of the led strip */
//    wt = 3DP_MEDIUM_TOLERANCE, /* wt - width tolerance of the led strip  */
//    ht = 3DP_MEDIUM_TOLERANCE  /* ht - height tolerance of the led strip */
) {
    difference() {
        color("dodgerblue", 1.0) cube([ENCLOSURE_EXTERNAL_LENGTH, ENCLOSURE_EXTERNAL_WIDTH, ENCLOSURE_LIP_THICKNESS ], true);
        cube([ENCLOSURE_INTERNAL_LENGTH, ENCLOSURE_INTERNAL_WIDTH, ENCLOSURE_LIP_THICKNESS + .2 ], true);
    }   
}

module row_of_holes(
    diameter,  /* diameter of hole */
    depth,     /* depth of hole */
    count = 1, /* number of holes to generate */
    spacing,   /* space between holes */
) {
    for (i=[0:count]){
        translate([i*spacing, 0, 0]) cylinder(depth, d=diameter, center=true, $fn=360);
    }
}

difference() {
    union() {
        mount(
            ENCLOSURE_EXTERNAL_LENGTH,
            ENCLOSURE_EXTERNAL_WIDTH,
            ENCLOSURE_LIP_THICKNESS,
            ENCLOSURE_INTERNAL_LENGTH,
            ENCLOSURE_INTERNAL_WIDTH
        );
        rail(
            ENCLOSURE_EXTERNAL_LENGTH,
            ENCLOSURE_EXTERNAL_WIDTH,
            RAIL_HEIGHT,
            LED_HOLDER_LENGTH,
            LED_HOLDER_WIDTH,
            LED_HOLDER_HEIGHT,
            LED_BAR_LENGTH,
            LED_BAR_WIDTH,
            LED_BAR_HEIGHT);
        }
    
    color("Chartreuse", 1.0) translate([-ENCLOSURE_EXTERNAL_LENGTH_BETWEEN_HOLE_CENTER, -(ENCLOSURE_EXTERNAL_WIDTH_BETWEEN_HOLE_CENTER/2), 0]) row_of_holes(
        ENCLOSURE_BOLT_HOLE_DIAMETER,
        ENCLOSURE_LIP_THICKNESS + .2,
        3,
        ENCLOSURE_EXTERNAL_LENGTH_BETWEEN_HOLE_CENTER
    );

    color("Chartreuse", 1.0) translate([-ENCLOSURE_EXTERNAL_LENGTH_BETWEEN_HOLE_CENTER, ENCLOSURE_EXTERNAL_WIDTH_BETWEEN_HOLE_CENTER/2, 0]) row_of_holes(
        ENCLOSURE_BOLT_HOLE_DIAMETER,
        ENCLOSURE_LIP_THICKNESS + .2,
        3,
        ENCLOSURE_EXTERNAL_LENGTH_BETWEEN_HOLE_CENTER
    );
}

