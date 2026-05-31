// PERCY UNIT v1 - FULL ASSEMBLY VIEW
// Shows all parts assembled together (for reference only)
// Each part can be exported separately from their own files

// Assembly scale reference (not for printing)
// This shows how all the parts connect

module assembly_placeholder() {
    // Chest plate at center
    translate([100, 0, 0])
        import("chest-plate.stl");
    
    // Neck + Head on top of chest
    translate([100, 0, 105])
        import("head-neck.stl");
    
    // Arms on sides
    translate([50, 0, 70])
        import("arms.stl");
    translate([150, 0, 70])
        import("arms.stl");
    
    // Legs below chest
    translate([70, 0, -85])
        import("legs.stl");
    translate([130, 0, -85])
        import("legs.stl");
}

// NOTE: To print parts, open individual .scad files and export STL

// CONNECTION GUIDE:
//
// HEAD + NECK → CHEST
//   - Neck snaps into top of chest plate
//   - 3 snap-fit connectors
//
// ARMS → CHEST  
//   - Shoulder brackets mount to sides of chest
//   - 4 snap-fit connectors per side
//
// LEGS → CHEST
//   - Hip mounting plates snap to bottom of chest
//   - 4 snap-fit connectors per leg
//
// ALL CONNECTIONS ARE REVERSIBLE FOR DISASSEMBLY!