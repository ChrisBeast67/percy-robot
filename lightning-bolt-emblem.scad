// PERCY UNIT - Lightning Bolt Emblem
// OpenSCAD file - export to STL for 3D printing

// Parameters
bolt_width = 30;
bolt_height = 80;
bolt_depth = 8;

// Classic Percy lightning bolt shape
module lightning_bolt(w, h, d) {
    linear_extrude(height=d) {
        polygon(points=[
            [w*0.5, 0],           // bottom center
            [w*0.75, h*0.2],      // right upper
            [w*0.55, h*0.2],      // notch in
            [w*0.8, h*0.35],      // right mid
            [w*0.6, h*0.35],      // notch in
            [w*0.9, h*0.5],       // right upper mid
            [w*0.5, h*0.5],       // notch in
            [w*0.7, h*0.65],      // right notch
            [w*0.4, h*0.65],      // notch in
            [w*0.6, h*0.8],       // right upper
            [w*0.3, h*1],         // tip of bolt
            [w*0.45, h*0.75],     // notch
            [w*0.25, h*0.75],     // notch
            [w*0.35, h*0.5],      // left upper mid
            [w*0.2, h*0.5],       // notch
            [w*0.1, h*0.35],      // left upper
            [w*0.35, h*0.2],      // notch
            [w*0.15, h*0.2],      // left notch
            [w*0.25, 0]           // bottom left
        ]);
    }
}

difference() {
    lightning_bolt(bolt_width, bolt_height, bolt_depth);
    
    // Hex bolt hole for mounting
    translate([bolt_width*0.4, bolt_height*0.5, bolt_depth - 2])
        cylinder(d=6, h=4, $fn=6);
}

// Edge chamfer for smooth look
translate([0, 0, bolt_depth - 1])
    lightning_bolt(bolt_width, bolt_height, 2);