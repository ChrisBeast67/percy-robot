#!/usr/bin/env python3
"""Generate STL files for Percy Unit robot body parts - ACTUAL 3D MODELS"""

import numpy as np
from stl import mesh
import math

def create_box_mesh(width, height, depth, name="box"):
    """Create a simple box mesh"""
    # 8 corners
    h, w, d = depth/2, width/2, height/2
    cube = np.array([
        [-w, -d, -h], [w, -d, -h], [w, d, -h], [-w, d, -h],  # bottom
        [-w, -d, h], [w, -d, h], [w, d, h], [-w, d, h]         # top
    ])
    
    faces = np.array([
        [0, 3, 1], [1, 3, 2],  # bottom
        [4, 5, 7], [5, 6, 7],  # top
        [0, 1, 5], [0, 5, 4],  # front
        [1, 2, 6], [1, 6, 5],  # right
        [2, 3, 7], [2, 7, 6],  # back
        [3, 0, 4], [3, 4, 7],  # left
    ])
    
    m = mesh.Mesh(np.zeros(len(faces), dtype=mesh.Mesh.dtype))
    for i, face in enumerate(faces):
        m.vectors[i] = cube[face]
    return m

def create_cylinder_mesh(radius, height, segments=16, name="cylinder"):
    """Create a cylinder mesh"""
    h = height / 2
    vertices = [[0, 0, -h], [0, 0, h]]  # center bottom, center top
    
    angles = np.linspace(0, 2*math.pi, segments, endpoint=False)
    for angle in angles:
        vertices.append([radius * math.cos(angle), radius * math.sin(angle), -h])
        vertices.append([radius * math.cos(angle), radius * math.sin(angle), h])
    
    vertices = np.array(vertices)
    n = len(vertices)
    
    faces = []
    # Bottom triangles
    for i in range(segments):
        faces.append([0, 2+i*2, 2+((i+1)%segments)*2])
    
    # Top triangles
    for i in range(segments):
        faces.append([1, 2+((i+1)%segments)*2+1, 2+i*2+1])
    
    # Side triangles
    for i in range(segments):
        next_i = (i+1) % segments
        # Front face
        faces.append([2+i*2, 2+i*2+1, 2+next_i*2])
        faces.append([2+next_i*2, 2+i*2+1, 2+next_i*2+1])
    
    faces = np.array(faces)
    m = mesh.Mesh(np.zeros(len(faces), dtype=mesh.Mesh.dtype))
    for i, face in enumerate(faces):
        m.vectors[i] = vertices[face]
    return m

def create_cone_mesh(radius, height, segments=16):
    """Create a cone mesh (for cat ears)"""
    h = height / 2
    vertices = [[0, 0, -h], [0, 0, h]]  # center bottom, tip top
    
    angles = np.linspace(0, 2*math.pi, segments, endpoint=False)
    for angle in angles:
        vertices.append([radius * math.cos(angle), radius * math.sin(angle), -h])
    
    vertices = np.array(vertices)
    
    faces = []
    # Bottom triangles (center to edge)
    for i in range(segments):
        faces.append([0, 2+i, 2+((i+1)%segments)])
    
    # Side triangles (tip to edge)
    for i in range(segments):
        next_i = (i+1) % segments
        faces.append([1, 2+next_i, 2+i])
    
    faces = np.array(faces)
    m = mesh.Mesh(np.zeros(len(faces), dtype=mesh.Mesh.dtype))
    for i, face in enumerate(faces):
        m.vectors[i] = vertices[face]
    return m

def create_chest_plate_stl():
    """Create chest plate with lightning bolt shape - APPROXIMATED"""
    width, height, depth = 80, 90, 15
    
    # Main chest plate (rounded approximation using box)
    chest = create_box_mesh(width, height, depth, "chest")
    
    # Add dome on top for chest curve (simplified)
    # We'll just return the box for now - user can smooth in OpenSCAD
    return chest

def create_cat_ear_stl():
    """Create cat ear shape - cone with flat top"""
    radius = 15
    height_val = 40
    
    ear = create_cone_mesh(radius, height_val, segments=16)
    return ear

def create_lightning_bolt_stl():
    """Create lightning bolt emblem - triangular prism approximation"""
    # Create a simplified bolt as an extruded triangle path
    # Using a box as approximation (user can refine in OpenSCAD)
    bolt = create_box_mesh(25, 60, 8, "bolt")
    return bolt

def create_shoulder_pad_stl():
    """Create shoulder pad - rounded box"""
    pad = create_box_mesh(50, 35, 20, "shoulder")
    return pad

def save_stl(mesh_obj, filename):
    """Save mesh to STL file"""
    mesh_obj.save(filename)
    print(f"Saved: {filename}")

# Generate all parts
print("=" * 50)
print("PERCY UNIT v1 - Generating STL Files")
print("=" * 50)

output_dir = "/home/chris/.openclaw/workspace/percy-robot/"

print("\n[1/4] Creating Chest Plate...")
chest = create_chest_plate_stl()
save_stl(chest, output_dir + "chest-plate.stl")

print("\n[2/4] Creating Cat Ears...")
left_ear = create_cat_ear_stl()
save_stl(left_ear, output_dir + "cat-ear-left.stl")
right_ear = create_cat_ear_stl()
save_stl(right_ear, output_dir + "cat-ear-right.stl")

print("\n[3/4] Creating Lightning Bolt Emblem...")
bolt = create_lightning_bolt_stl()
save_stl(bolt, output_dir + "lightning-bolt.stl")

print("\n[4/4] Creating Shoulder Pads...")
left_pad = create_shoulder_pad_stl()
save_stl(left_pad, output_dir + "shoulder-pad-left.stl")
right_pad = create_shoulder_pad_stl()
save_stl(right_pad, output_dir + "shoulder-pad-right.stl")

print("\n" + "=" * 50)
print("ALL STL FILES GENERATED!!")
print("=" * 50)
print("""
FILES CREATED:
- chest-plate.stl (80x90x15mm)
- cat-ear-left.stl (r=15mm, h=40mm)
- cat-ear-right.stl (r=15mm, h=40mm)
- lightning-bolt.stl (25x60x8mm)
- shoulder-pad-left.stl (50x35x20mm)
- shoulder-pad-right.stl (50x35x20mm)

NOTE: These are BASIC shapes. For more detailed parts,
download the .scad files from GitHub and open in OpenSCAD
to get the FULL designs with lightning bolt cutouts etc!

GitHub: https://github.com/ChrisBeast67/percy-robot
""")