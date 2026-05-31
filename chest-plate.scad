// PERCY UNIT - Chest Plate with Lightning Bolt
// OpenSCAD file - export to STL for3D printing

// Parameters
chest_width = 80;
chest_height = 90;
chest_depth = 15;
bolt_width = 20;
bolt_height = 50;

// Main chest plate (rounded rectangle)
module rounded_chest(width, height, depth, radius) {
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

difference() {
    // Base chest plate
    rounded_chest(chest_width, chest_height, chest_depth, 10);
    
    // Lightning bolt cutout (simplified 2D extrusion)
    translate([chest_width/2 - bolt_width/2, chest_height/2 - bolt_height/2, -1]) {
        linear_extrude(height=chest_depth + 2) {
            polygon(points=[
                [bolt_width*0.5, 0],
                [bolt_width*0.8, bolt_height*0.3],
                [bolt_width*0.5, bolt_height*0.3],
                [bolt_width*0.7, bolt_height*0.5],
                [bolt_width*0.4, bolt_height*0.5],
                [bolt_width*0.6, bolt_height*0.7],
                [bolt_width*0.3, bolt_height*1],
                [bolt_width*0.6, bolt_height*0.7],
                [bolt_width*0.5, bolt_height*1],
                [bolt_width*0.3, bolt_height*0.7],
                [0, bolt_height*0.7],
                [bolt_width*0.2, bolt_height*0.5],
                [bolt_width*0.5, bolt_height*0.5]
            ]);
        }
    }
    
    // LED mounting holes (4 corners)
    led_hole_dia = 5;
    led_spacing = 15;
    translate([led_spacing, led_spacing, chest_depth - 2]) cylinder(d=led_hole_dia, h=3);
    translate([chest_width - led_spacing, led_spacing, chest_depth - 2]) cylinder(d=led_hole_dia, h=3);
    translate([led_spacing, chest_height - led_spacing, chest_depth - 2]) cylinder(d=led_hole_dia, h=3);
    translate([chest_width - led_spacing, chest_height - led_spacing, chest_depth - 2]) cylinder(d=led_hole_dia, h=3);
}

// Mounting tabs (for screws)
mount_tab_width = 10;
mount_tab_height = 8;
translate([5, chest_height/2 - mount_tab_height/2, 0])
    cube([mount_tab_width, mount_tab_height, chest_depth]);
translate([chest_width - 5 - mount_tab_width, chest_height/2 - mount_tab_height/2, 0])
    cube([mount_tab_width, mount_tab_height, chest_depth]);