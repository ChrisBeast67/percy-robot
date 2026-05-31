// PERCY UNIT - Shoulder Pads (x2)
// OpenSCAD file - export to STL for 3D printing

// Parameters
pad_width = 50;
pad_depth = 35;
pad_height = 20;
curve_radius = 10;

// Rounded shoulder pad shape
module shoulder_pad(w, d, h, r) {
    hull() {
        translate([r, r, 0])
            cylinder(r=r, h=h);
        translate([w - r, r, 0])
            cylinder(r=r, h=h);
        translate([r, d - r, 0])
            cylinder(r=r, h=h);
        translate([w - r, d - r, 0])
            cylinder(r=r, h=h);
    }
}

difference() {
    shoulder_pad(pad_width, pad_depth, pad_height, curve_radius);
    
    // Curved arm hole (for shoulder joint)
    translate([pad_width/2, pad_depth*0.7, pad_height*0.4])
        rotate([90, 0, 0])
            cylinder(d=pad_depth*0.6, h=pad_height*0.8);
    
    // LED channel groove
    translate([pad_width*0.2, pad_depth*0.3, pad_height - 3])
        cube([pad_width*0.6, pad_depth*0.15, 3]);
}

// Mounting holes (4 corners)
mount_hole_dia = 4;
translate([8, 8, pad_height - 2]) cylinder(d=mount_hole_dia, h=3);
translate([pad_width - 8, 8, pad_height - 2]) cylinder(d=mount_hole_dia, h=3);
translate([8, pad_depth - 8, pad_height - 2]) cylinder(d=mount_hole_dia, h=3);
translate([pad_width - 8, pad_depth - 8, pad_height - 2]) cylinder(d=mount_hole_dia, h=3);