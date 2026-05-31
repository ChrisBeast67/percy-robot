// PERCY UNIT v1 - ARM MODULES WITH SNAP-FITS
// Left and Right arms that connect to shoulders

// Parameters
shoulder_width = 40;
shoulder_height = 35;
shoulder_depth = 20;

upper_arm_length = 55;
upper_arm_width = 25;
upper_arm_depth = 22;

elbow_dia = 18;

lower_arm_length = 50;
lower_arm_width = 22;
lower_arm_depth = 20;

hand_width = 35;
hand_height = 45;
hand_depth = 15;

snap_dia = 6;
snap_height = 5;

// Snap-fit male
module snap_male(dia, height) {
    cylinder(d=dia, h=height);
    translate([0, 0, height])
        cylinder(d1=dia, d2=dia*0.7, h=height*0.5);
}

// SHOULDER JOINT MODULE
module shoulder_joint() {
    // Ball socket
    difference() {
        sphere(d=shoulder_width);
        // Hollow out for joint
        translate([0, 0, -shoulder_width/2])
            sphere(d=shoulder_width*0.6);
    }
    
    // LED accent ring
    translate([0, 0, shoulder_width/2])
        torus(r=shoulder_width*0.7, h=2);
}

// UPPER ARM MODULE
module upper_arm() {
    // Main arm shape
    hull() {
        translate([upper_arm_width/2, upper_arm_depth/2, 0])
            cylinder(d=upper_arm_width, h=upper_arm_depth);
        translate([upper_arm_width/2, upper_arm_depth/2, upper_arm_length])
            cylinder(d=upper_arm_width*0.85, h=upper_arm_depth);
    }
    
    // Lightening holes
    for (z = [10:15:upper_arm_length-10]) {
        translate([upper_arm_width/2, upper_arm_depth/2, z])
            rotate([90, 0, 0])
                cylinder(d=upper_arm_width*0.4, h=upper_arm_depth + 2);
    }
    
    // Shoulder ball joint (male)
    translate([upper_arm_width/2, upper_arm_depth/2, 0])
        sphere(d=shoulder_width*0.9);
    
    // Elbow connection (female socket)
    translate([upper_arm_width/2, upper_arm_depth/2, upper_arm_length])
        cylinder(d=elbow_dia, h=upper_arm_depth);
    
    // Snap-fit male for torso mount
    translate([0, -upper_arm_depth/2, upper_arm_length/2])
        rotate([90, 0, 0])
            snap_male(snap_dia, snap_height);
}

// ELBOW JOINT MODULE
module elbow_joint() {
    // Elbow ball
    sphere(d=elbow_dia);
    
    // Connection cylinders
    translate([0, 0, -elbow_dia/2])
        cylinder(d=elbow_dia*0.8, h=elbow_dia/2);
    translate([0, 0, elbow_dia/2])
        cylinder(d=elbow_dia*0.8, h=elbow_dia/2);
}

// LOWER ARM MODULE
module lower_arm() {
    // Main forearm shape
    hull() {
        translate([lower_arm_width/2, lower_arm_depth/2, 0])
            cylinder(d=lower_arm_width, h=lower_arm_depth);
        translate([lower_arm_width/2, lower_arm_depth/2, lower_arm_length])
            cylinder(d=lower_arm_width*0.8, h=lower_arm_depth);
    }
    
    // Lightening holes
    for (z = [10:15:lower_arm_length-10]) {
        translate([lower_arm_width/2, lower_arm_depth/2, z])
            rotate([90, 0, 0])
                cylinder(d=lower_arm_width*0.35, h=lower_arm_depth + 2);
    }
    
    // Wrist joint
    translate([lower_arm_width/2, lower_arm_depth/2, lower_arm_length])
        sphere(d=lower_arm_width*0.7);
    
    // LED strip channel
    translate([lower_arm_width/2 - 3, lower_arm_depth + 2, lower_arm_length*0.3])
        cube([6, 3, lower_arm_length*0.4]);
}

// HAND MODULE
module percy_hand() {
    // Palm
    hull() {
        translate([5, 5, 0])
            cylinder(r=5, h=hand_depth);
        translate([hand_width - 5, 5, 0])
            cylinder(r=5, h=hand_depth);
        translate([5, hand_height - 5, 0])
            cylinder(r=5, h=hand_depth);
        translate([hand_width - 5, hand_height - 5, 0])
            cylinder(r=5, h=hand_depth);
    }
    
    // Fingers (simplified)
    finger_width = 6;
    finger_spacing = 8;
    for (i = [0:3]) {
        translate([finger_spacing + i*finger_width, hand_height - 5, hand_depth/2])
            rotate([90, 0, 0])
                cylinder(d=finger_width, h=hand_depth*0.6);
    }
    
    // Thumb
    translate([hand_width - 8, hand_height*0.4, hand_depth/2])
        rotate([0, 90, 0])
            cylinder(d=finger_width, h=10);
    
    // Wrist connection
    translate([hand_width/2,0, hand_depth/2])
        rotate([90, 0, 0])
            cylinder(d=lower_arm_width*0.7, h=10);
    
    // LED palm glow
    translate([hand_width/2, hand_height*0.6, -1])
        cylinder(d=10, h=3);
}

// FULL ARM ASSEMBLY
module arm_assembled(is_left) {
    arm_offset = is_left ? 0 : 0;
    
    // Shoulder joint
    translate([arm_offset, 0, 0])
        shoulder_joint();
    
    // Upper arm
    translate([arm_offset, 0, 0])
        upper_arm();
    
    // Elbow
    translate([arm_offset, 0, upper_arm_length + shoulder_depth/2])
        elbow_joint();
    
    // Lower arm
    translate([arm_offset, 0, upper_arm_length + shoulder_depth/2])
        lower_arm();
    
    // Hand
    translate([arm_offset, 0, upper_arm_length + lower_arm_length + shoulder_depth/2])
        rotate([90, 0, 0])
            percy_hand();
}

// SNAP-FIT SHOULDER BRACKET (for chest connection)
module shoulder_bracket() {
    bracket_width = 50;
    bracket_height = 40;
    
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
        
        // Snap-fit females for chest mount
        translate([10, bracket_height/2, -1])
            cylinder(d=snap_dia + 1, h=7);
        translate([bracket_width - 10, bracket_height/2, -1])
            cylinder(d=snap_dia + 1, h=7);
    }
}

// Export arm
arm_assembled(true);  // Left arm