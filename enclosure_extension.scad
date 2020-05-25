//TOLERANCE = .2;
//MAGNET_TOLERANCE = .4;

NO_TOLERANCE = 0;
3DP_TIGHT_TOLERANCE = .2;
3DP_MEDIUM_TOLERANCE = .4;

//WITH_LID = 0;
//LID_ONLY = 1;
//BOX_ONLY = 2;

//LED Strip MM - Length: 1000, Width: 12, Height: 4
//Enclosure Dimensions MM - Outside -> Length: 533.4, Width: 184.15, Height: 44.45 Inner -> Length: 485.422, Width: 146.05, Height: 41.275
//Battery Dimensions MM - 350mm Length * 140mm Width * 46mm Height
ENCLOSURE_LENGTH = 533.4;
ENCLOSURE_WIDTH = 184.14;
ENCLOSURE_HEIGHT = 44.45;

LED_BAR_LENGTH = ENCLOSURE_LENGTH;
LED_BAR_WIDTH = 12;
LED_BAR_HEIGHT = 4;

LED_LENGTH = 5;
LED_WIDTH = 5;
LED_HEIGHT = 5;

PROTO_LED_BAR_LENGTH = 72;
PROTO_LED_BAR_WIDTH = 12;
PROTO_LED_BAR_HEIGHT = 4;

PROTO_LED_HOLDER_WALLS = 2;

PROTO_LED_HOLDER_LENGTH = PROTO_LED_BAR_LENGTH;
PROTO_LED_HOLDER_WIDTH = PROTO_LED_BAR_WIDTH + PROTO_LED_HOLDER_WALLS;
PROTO_LED_HOLDER_HEIGHT = PROTO_LED_BAR_HEIGHT + PROTO_LED_HOLDER_WALLS;

PROTO_RAIL_LENGTH = PROTO_LED_BAR_LENGTH;
PROTO_RAIL_WIDTH = 25.4;
PROTO_RAIL_HEIGHT = 12.7;

CASE_THICKNESS = 2.51;
CASE_LIP_WIDTH = 12.7;
    
//    echo("l = ", l);
//    echo("w = ", w);
//    echo("h = ", h);
//    echo("ll = ", ll);
//    echo("lw = ", lw);
//    echo("lh = ", lh);
//    echo("lt = ", lt);
//    echo("wt = ", wt);
//    echo("ht = ", ht);

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
    
    //union() {
        rotate([90, 0, 0]) difference() {
            color("dodgerblue", 1.0) cube([dh*2+4.45, l, dh+4], true);
            translate([-dh, 0, -dh/2]) rotate([0, 225, 0]) color("aquamarine", 1.0) negative(hl, hw, hh, ll, lw, lh, lt, wt, ht);
            translate([CASE_LIP_WIDTH/2-.5, 0, 0]) cube([CASE_LIP_WIDTH, l+.2, CASE_THICKNESS], true);
    }
}

//negative(PROTO_LED_HOLDER_LENGTH, PROTO_LED_HOLDER_WIDTH, PROTO_LED_HOLDER_HEIGHT, PROTO_LED_BAR_LENGTH, PROTO_LED_BAR_WIDTH, PROTO_LED_BAR_HEIGHT);

rail(PROTO_RAIL_LENGTH, PROTO_RAIL_WIDTH, PROTO_RAIL_HEIGHT, PROTO_LED_HOLDER_LENGTH, PROTO_LED_HOLDER_WIDTH, PROTO_LED_HOLDER_HEIGHT, PROTO_LED_BAR_LENGTH, PROTO_LED_BAR_WIDTH, PROTO_LED_BAR_HEIGHT);
