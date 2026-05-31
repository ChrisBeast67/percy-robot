// PERCY UNIT v1 - PRECISE CHEST PLATE WITH SNAP-FITS
// Has lightning bolt cutout, LED holes, and snap-fit mounting points

// Parameters (all in mm)
chest_width = 80;
chest_height = 90;
chest_depth = 15;
wall_thickness = 3;
bolt_width = 25;
bolt_height = 55;

// SNAP-FIT CONNECTORS
snap_diameter = 6;
snap_height = 5;

// LED Ring parameters
led_hole_dia = 5;
led_count = 8;
led_ring_radius = 25;

// Rounded box module
module rounded_box(width, height, depth, radius) {
    hull() {
        translate([radius, radius, 0])
            cylinder(r=radius, h=depth);
        translate([width - radius, radius, 0])
            cylinder(r=radius, h=depth);
        translate([radius, height - radius, 0])
            cylinder(r=radius, h=depth);
        translate([width - radius, height - radius, 0])
            cylinder(r=radius, h=depth);
    }
}

// Snap-fit male connector
module snap_male(dia, height) {
    cylinder(d=dia, h=height);
    translate([0, 0, height])
        cylinder(d1=dia, d2=dia*0.7, h=height*0.5);
}

// Snap-fit female connector
module snap_female(dia, depth) {
    cylinder(d=dia + 1, h=depth);
    translate([0, 0, depth - 2])
        cylinder(d=dia + 0.5, h=2);  // catch rim
}

// Difference module for cutouts
difference() {
    // Main chest plate (hollow box)
    difference() {
        rounded_box(chest_width, chest_height, chest_depth, 10);
        // Hollow out inside
        translate([wall_thickness, wall_thickness, wall_thickness])
            rounded_box(chest_width - wall_thickness*2, 
                       chest_height - wall_thickness*2, 
                       chest_depth +1, 
                       8);
    }
    
    // Lightning bolt cutout
    translate([chest_width/2 - bolt_width/2, chest_height/2 - bolt_height/2, -1]) {
        linear_extrude(height=chest_depth + 2) {
            polygon(points=[
                [bolt_width*0.5, 0],
                [bolt_width*0.85, bolt_height*0.15],
                [bolt_width*0.6, bolt_height*0.15],
                [bolt_width*0.75, bolt_height*0.35],
                [bolt_width*0.55, bolt_height*0.35],
                [bolt_width*0.9, bolt_height*0.55],
                [bolt_width*0.5, bolt_height*0.55],
                [bolt_width*0.7, bolt_height*0.75],
                [bolt_width*0.35, bolt_height*0.75],
                [bolt_width*0.55, bolt_height*0.95],
                [bolt_width*0.3, bolt_height*1.0],
                [bolt_width*0.45, bolt_height*0.7],
                [bolt_width*0.2, bolt_height*0.7],
                [bolt_width*0.35, bolt_height*0.5],
                [bolt_width*0.15, bolt_height*0.5],
                [bolt_width*0.1, bolt_height*0.35],
                [bolt_width*0.35, bolt_height*0.15],
                [bolt_width*0.1, bolt_height*0.15]
            ]);
        }
    }
    
    // LED ring holes
    for (i = [0:led_count-1]) {
        angle = i * 360 / led_count;
        x = chest_width/2 + led_ring_radius * cos(angle);
        y = chest_height/2 + led_ring_radius * sin(angle);
        translate([x, y, chest_depth - 2])
            cylinder(d=led_hole_dia, h=3);
    }
}

// SNAP-FIT CONNECTORS (male studs for assembly)
// Bottom mounting snaps
translate([15, 5, chest_depth/2])
    rotate([90, 0, 0])
        snap_male(snap_diameter, snap_height);
translate([chest_width - 15, 5, chest_depth/2])
    rotate([90, 0, 0])
        snap_male(snap_diameter, snap_height);

// Side mounting snaps (for shoulder connection)
translate([5, chest_height/2, chest_depth/2])
    rotate([0, 90, 0])
        snap_male(snap_diameter, snap_height);
translate([chest_width - 5, chest_height/2, chest_depth/2])
    rotate([0, 90, 0])
        snap_male(snap_diameter, snap_height);

// Top mounting snaps (for neck/head connection)
translate([chest_width/2, chest_height - 5, chest_depth/2])
    rotate([0, 180, 0])
        snap_male(snap_diameter, snap_height);

// Screw holes at corners
corner_offset = 8;
translate([corner_offset, corner_offset, chest_depth - 3])
    cylinder(d=4, h=4);  # M4 screw hole
translate([chest_width - corner_offset, corner_offset, chest_depth - 3])
    cylinder(d=4, h=4);
translate([corner_offset, chest_height - corner_offset, chest_depth - 3])
    cylinder(d=4, h=4);
translate([chest_width - corner_offset, chest_height - corner_offset, chest_depth - 3])
    cylinder(d=4, h=4);