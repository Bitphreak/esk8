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

LED_BAR_WIDTH = 12;
LED_BAR_HEIGHT = 4;

LED_LENGTH = 5;
LED_WIDTH = 5;
LED_HEIGHT = 5;

LED_HOLDER_WALLS = 2;
LED_HOLDER_WIDTH = LED_BAR_WIDTH + LED_HOLDER_WALLS;
LED_HOLDER_HEIGHT = LED_BAR_HEIGHT + LED_HOLDER_WALLS;

RAIL_LENGTH = ENCLOSURE_LENGTH;
RAIL_WIDTH = 25.4;
RAIL_HEIGHT = 12.7;

CASE_THICKNESS = 2.51;
CASE_LIP_WIDTH = 12.7;

module negative(
    dh, /* dh */
    top, /* top */
    offset, /* offset */
    l,  /* length of the holder */
    lw, /* width of the led strip  */
    lt, /* length tolerance of the led strip */
    wt, /* width tolerance of the led strip  */
    ht, /* height tolerance of the led strip */
    ) {

        echo("l = ", l);
        echo("lt = ", lt);
        union() {
            color("aquamarine", 1.0) cube([dh + (2 * wt), l + (2 * lt), dh + ht], true);
            color("midnightblue", 1.0) cube([lw + (2 * wt), l + (2 * lt), lh + ht], true);
        }    
}
        
/**
*/
module rail(
    l,   /* length of the rail */
    dh, /* dh */
    top, /* top */
    offset, /* offset */
    hw,  /* width of the holder  */
    hh,  /* height of the led strip */
    ll,  /* length of the led strip */
    lw,  /* width of the led strip  */
    lh,  /* height of the led strip */
    clp, /* width of case lip */
    ct, /* thickness of case */
    lt = 3DP_MEDIUM_TOLERANCE, /* length tolerance of the led strip */
    wt = 3DP_MEDIUM_TOLERANCE, /* width tolerance of the led strip  */
    ht = 3DP_MEDIUM_TOLERANCE,  /* height tolerance of the led strip */
    debug = false
    ) {
    
    //union() {
        /*rotate([90, 0, 0])*/
        difference() {
            color("dodgerblue", 1.0) cube([dh*2+4.45, l, dh+4], true);
            translate([-dh, 0, -dh/2]) rotate([0, 225, 0]) color("aquamarine", 1.0) negative(dh, top, offset, l, lw, lt, wt, ht);
            translate([CASE_LIP_WIDTH/2-.5, 0, 0]) cube([clp, l+.2, ct], true);
    }
}

module enclosure_extension(debug = false){
    // Calculate Dimensions
    dh = LED_HOLDER_WIDTH / 2 * sqrt(2);
    top = dh/2;
    offset = lh/2 + top + .1;

    if (debug) {
        echo("l = ", l);
        echo("w = ", w);
        echo("h = ", h);
        echo("ll = ", ll);
        echo("lw = ", lw);
        echo("lh = ", lh);
        echo("lt = ", lt);
        echo("wt = ", wt);
        echo("ht = ", ht);
    }
    
    rail(RAIL_LENGTH, dh, top, offset, LED_HOLDER_WIDTH, LED_HOLDER_HEIGHT, RAIL_LENGTH, LED_BAR_WIDTH, LED_BAR_HEIGHT, CASE_LIP_WIDTH, CASE_THICKNESS);

}

enclosure_extension();
