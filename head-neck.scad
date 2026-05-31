// PERCY UNIT v1 - HEAD AND NECK MODULE WITH SNAP-FITS
// Connects to chest plate via neck

// Parameters
neck_dia = 20;
neck_length = 25;
neck_depth = 15;

head_width = 70;
head_height = 80;
head_depth = 65;

eye_dia = 25;
eye_spacing = 30;
eye_offset_z = 10;

ear_height = 45;
ear_width = 25;
ear_depth = 15;
ear_offset_x = 40;
ear_offset_z = 50;

snap_dia = 6;
snap_height = 5;

// NECK MODULE
module neck() {
    // Main neck cylinder
    difference() {
        cylinder(d=neck_dia, h=neck_length);
        
        // Lightening holes
        for (angle = [0:45:359]) {
            translate([neck_dia*0.4 * cos(angle), neck_dia*0.4 * sin(angle), 0])
                cylinder(d=5, h=neck_length + 1);
        }
    }
    
    // Top snap-fit male (for head connection)
    translate([neck_dia/2, neck_dia/2, neck_length])
        cylinder(d=snap_dia, h=snap_height);
    
    // Bottom snap-fit female (for chest connection)
    translate([neck_dia/2, neck_dia/2, 0])
        cylinder(d=snap_dia + 1, h=3);
}

// HEAD MODULE
module percy_head() {
    // Main head shape (rounded box)
    hull() {
        translate([10, 10, 10])
            sphere(r=10);
        translate([head_width - 10, 10, 10])
            sphere(r=10);
        translate([10, head_depth - 10, 10])
            sphere(r=10);
        translate([head_width - 10, head_depth - 10, 10])
            sphere(r=10);
        translate([10, 10, head_height - 10])
            sphere(r=10);
        translate([head_width - 10, 10, head_height - 10])
            sphere(r=10);
        translate([10, head_depth - 10, head_height - 10])
            sphere(r=10);
        translate([head_width - 10, head_depth - 10, head_height - 10])
            sphere(r=10);
    }
    
    // Eye sockets (large holes for LED eyes)
    eye_x_start = head_width/2 - eye_spacing/2;
    eye_x_end = head_width/2 + eye_spacing/2;
    
    translate([eye_x_start, head_depth/2, eye_offset_z])
        cylinder(d=eye_dia, h=20);
    translate([eye_x_end, head_depth/2, eye_offset_z])
        cylinder(d=eye_dia, h=20);
    
    // Eye glow rings
    translate([eye_x_start, head_depth/2, eye_offset_z])
        cylinder(d=eye_dia + 3, h=3);
    translate([eye_x_end, head_depth/2, eye_offset_z])
        cylinder(d=eye_dia + 3, h=3);
    
    // Mouth slot
    translate([head_width/2 - 15, head_depth - 5, head_height*0.3])
        cube([30, 10, 15]);
    
    // Visor groove (for face shield)
    translate([10, head_depth + 2, head_height*0.4])
        cube([head_width - 20, 5, head_height*0.3]);
}

// CAT EARS (attach to head)
module cat_ear(is_left) {
    ear_x = is_left ? -ear_offset_x : head_width + ear_offset_x;
    mirror_x = is_left ? -1 : 1;
    
    translate([head_width/2, head_depth/2, head_height]) {
        // Main ear cone
        translate([0, 0,0])
            cylinder(d1=ear_width, d2=5, h=ear_height);
        
        // Inner ear detail
        translate([0, 0, 5])
            cylinder(d1=ear_width*0.6, d2=3, h=ear_height*0.8);
        
        // LED strip slot
        translate([0, 0, ear_height*0.5])
            cylinder(d=3, h=ear_height*0.3);
    }
}

// Full head assembly with neck
module head_with_neck() {
    // Neck
    translate([head_width/2 - neck_dia/2, head_depth/2 - neck_dia/2, 0])
        neck();
    
    // Head on top of neck
    translate([0, 0, neck_length])
        percy_head();
    
    // Cat ears
    translate([0, 0, 0])
        cat_ear(true);  // Left ear
    translate([0, 0, 0])
        cat_ear(false);  // Right ear
}

// SNAP-FIT MOUNTING BRACKET (for chest connection)
module chest_neck_bracket() {
    bracket_width = 40;
    bracket_height = 30;
    
    difference() {
        hull() {
            translate([5, 5, 0])
                cylinder(r=5, h=5);
            translate([bracket_width - 5, 5, 0])
                cylinder(r=5, h=5);
            translate([5, bracket_height - 5, 0])
                cylinder(r=5, h=5);
            translate([bracket_width - 5, bracket_height - 5, 0])
                cylinder(r=5, h=5);
        }
        
        // Snap-fit females
        translate([10, bracket_height/2, -1])
            cylinder(d=snap_dia + 1, h=7);
        translate([bracket_width - 10, bracket_height/2, -1])
            cylinder(d=snap_dia + 1, h=7);
    }
}

// Export head with neck
head_with_neck();

// Or export parts separately:
// neck();
// percy_head();
// cat_ear(true);
// cat_ear(false);
// chest_neck_bracket();