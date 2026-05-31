// PERCY UNIT v1 - LEG MODULES WITH SNAP-FITS
// Left and Right legs that connect to torso

// Parameters
leg_upper_length = 60;
leg_lower_length = 55;
leg_width = 30;
leg_depth = 25;
joint_dia = 20;
foot_length = 50;
foot_width = 40;
foot_height = 10;
snap_dia = 6;
snap_height = 5;

// Snap-fit male
module snap_male(dia, height) {
    cylinder(d=dia, h=height);
    translate([0, 0, height])
        cylinder(d1=dia, d2=dia*0.7, h=height*0.5);
}

// Rounded box
module rounded_box(w, h, d, r) {
    hull() {
        translate([r, r, 0])
            sphere(r=r);
        translate([w - r, r, 0])
            sphere(r=r);
        translate([r, h - r, 0])
            sphere(r=r);
        translate([w - r, h - r, 0])
            sphere(r=r);
    }
}

// Sphere joint (for hip/knee)
module sphere_joint(dia) {
    sphere(d=dia);
}

// Hip joint ball
module hip_joint() {
    sphere(d=joint_dia);
}

// Knee joint
module knee_joint() {
    sphere(d=joint_dia * 0.8);
}

// Ankle joint
module ankle_joint() {
    sphere(d=joint_dia * 0.7);
}

// FOOT MODULE
module foot() {
    difference() {
        // Main foot
        hull() {
            translate([5, 5, 0])
                cylinder(r=5, h=foot_height);
            translate([foot_length - 5, 5, 0])
                cylinder(r=5, h=foot_height);
            translate([5, foot_width - 5, 0])
                cylinder(r=5, h=foot_height);
            translate([foot_length - 5, foot_width - 5, 0])
                cylinder(r=5, h=foot_height);
        }
        
        // Arch hollow
        translate([foot_length*0.3, foot_width/2, foot_height - 3])
            cylinder(d=foot_width*0.4, h=foot_height + 2);
    }
    
    // Grip texture on bottom
    for (x = [10:10:foot_length-10]) {
        for (y = [10:10:foot_width-10]) {
            translate([x, y, -0.5])
                cylinder(d=3, h=1);
        }
    }
    
    // LED strip channel
    translate([foot_length*0.2, 2, foot_height/2])
        cube([foot_length*0.6, 3, 4]);
}

// UPPER LEG MODULE
module upper_leg() {
    difference() {
        hull() {
            // Top (hip connection)
            cylinder(d=leg_width, h=leg_depth);
            // Bottom (knee area)
            translate([0, 0, leg_upper_length])
                cylinder(d=leg_width*0.9, h=leg_depth);
        }
        
        // Lightening holes
        for (y = [5:10:leg_upper_length-5]) {
            translate([leg_width/2, y, leg_depth/2])
                rotate([90, 0, 0])
                    cylinder(d=leg_width*0.4, h=leg_depth + 2);
        }
    }
    
    // Hip ball joint
    translate([leg_width/2, leg_depth/2, 0])
        hip_joint();
    
    // Knee connection (female socket)
    translate([leg_width/2, leg_depth/2, leg_upper_length])
        cylinder(d=joint_dia*0.85, h=leg_depth);
}

// LOWER LEG MODULE  
module lower_leg() {
    difference() {
        hull() {
            // Top (knee connection)
            translate([0, 0,0])
                cylinder(d=leg_width*0.9, h=leg_depth);
            // Bottom (ankle area)
            translate([0, 0, leg_lower_length])
                cylinder(d=leg_width*0.8, h=leg_depth);
        }
        
        // Lightening holes
        for (y = [5:10:leg_lower_length-5]) {
            translate([leg_width/2, y, leg_depth/2])
                rotate([90, 0, 0])
                    cylinder(d=leg_width*0.35, h=leg_depth + 2);
        }
    }
    
    // Knee connection (male ball)
    translate([leg_width/2, leg_depth/2, 0])
        knee_joint();
    
    // Ankle ball joint
    translate([leg_width/2, leg_depth/2, leg_lower_length])
        ankle_joint();
}

// ASSEMBLED LEG (left side shown)
module leg_assembled() {
    // Upper leg
    translate([0, 0, 0])
        upper_leg();
    
    // Lower leg
    translate([leg_width/2,0, leg_upper_length + leg_depth/2])
        rotate([90, 0, 0])
            lower_leg();
    
    // Foot
    translate([0, leg_depth/2 + leg_lower_length, leg_lower_length])
        rotate([90, 0, 0])
            foot();
}

// SNAP-FIT CONNECTORS for torso connection
// Located on upper leg for hip attachment
translate([leg_width/2,0, leg_depth])
    rotate([90, 0, 0])
        snap_male(snap_dia, snap_height);

// TORSO MOUNTING PLATE (for leg connection)
module torso_mounting_plate() {
    plate_width = 60;
    plate_height = 40;
    plate_depth = 5;
    
    difference() {
        rounded_box(plate_width, plate_height, plate_depth, 5);
        
        // Snap-fit females
        translate([10, plate_height/2, -1])
            cylinder(d=snap_dia + 1, h=plate_depth + 2);
        translate([plate_width - 10, plate_height/2, -1])
            cylinder(d=snap_dia + 1, h=plate_depth + 2);
    }
}

// Generate both legs by mirroring
module right_leg() {
    mirror([0, 0, 0])
        leg_assembled();
}

// Uncomment to see full assembly:
// leg_assembled();  // Left leg
// mirror([1, 0, 0]) leg_assembled();  // Right leg

// Or just export individual parts:
leg_assembled();  // Export this for printing