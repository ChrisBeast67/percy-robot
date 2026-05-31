// PERCY UNIT - Cat Ear Helmet Visors (x2)
// OpenSCAD file - export to STL for 3D printing

// Parameters
ear_height = 40;
ear_width = 30;
ear_depth = 12;
inner_curve = 8;

// Cat ear shape
module cat_ear(width, height, depth, curve) {
    hull() {
        // Base corner (rounded)
        translate([curve, curve, 0])
            cylinder(r=curve, h=depth);
        translate([width - curve, curve, 0])
            cylinder(r=curve, h=depth);
        // Peak of ear (pointy)
        translate([width/2, height - curve, 0])
            cylinder(r=curve*1.5, h=depth);
    }
}

// Single ear
difference() {
    cat_ear(ear_width, ear_height, ear_depth, inner_curve);
    
    // Hollow inside (to save material and be lighter)
    translate([ear_width*0.3, ear_depth, ear_depth*0.3])
        rotate([90, 0, 0])
            cylinder(d=ear_width*0.4, h=ear_depth*0.6);
}

// LED strip groove
translate([ear_width/2 - 3, ear_height*0.6, ear_depth/2])
    cube([6, ear_height*0.3, 3]);

// Mounting flange (for helmet attachment)
flange_width = 20;
flange_height = 5;
translate([ear_width/2 - flange_width/2, 0, 0])
    cube([flange_width, flange_height, ear_depth]);