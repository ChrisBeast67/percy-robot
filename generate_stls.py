#!/usr/bin/env python3
"""Generate DETAILED STL files for Percy Unit v1 - Precision Models"""

import numpy as np
from stl import mesh
import math
import os

output_dir = "/home/chris/.openclaw/workspace/percy-robot/"
os.makedirs(output_dir, exist_ok=True)

def create_box_mesh(width, height, depth):
    """Create a detailed box mesh"""
    h, w, d = depth/2, width/2, height/2
    cube = np.array([
        [-w, -d, -h], [w, -d, -h], [w, d, -h], [-w, d, -h],
        [-w, -d, h], [w, -d, h], [w, d, h], [-w, d, h]
    ])
    
    faces = np.array([
        [0, 3, 1], [1, 3, 2],
        [4, 5, 7], [5, 6, 7],
        [0, 1, 5], [0, 5, 4],
        [1, 2, 6], [1, 6, 5],
        [2, 3, 7], [2, 7, 6],
        [3, 0, 4], [3, 4, 7],
    ])
    
    m = mesh.Mesh(np.zeros(len(faces), dtype=mesh.Mesh.dtype))
    for i, face in enumerate(faces):
        m.vectors[i] = cube[face]
    return m

def create_cylinder_mesh(radius, height, segments=32):
    """Create a cylinder mesh"""
    h = height / 2
    vertices = [[0, 0, -h], [0, 0, h]]
    
    angles = np.linspace(0, 2*math.pi, segments, endpoint=False)
    for angle in angles:
        vertices.append([radius * math.cos(angle), radius * math.sin(angle), -h])
        vertices.append([radius * math.cos(angle), radius * math.sin(angle), h])
    
    vertices = np.array(vertices)
    
    faces = []
    for i in range(segments):
        next_i = (i+1) % segments
        base_i = 2 + i*2
        next_base_i = 2 + next_i*2
        faces.append([0, base_i, next_base_i])
        faces.append([1, next_base_i+1, base_i+1])
        faces.append([base_i, base_i+1, next_base_i])
        faces.append([next_base_i, base_i+1, next_base_i+1])
    
    faces = np.array(faces)
    m = mesh.Mesh(np.zeros(len(faces), dtype=mesh.Mesh.dtype))
    for i, face in enumerate(faces):
        m.vectors[i] = vertices[face]
    return m

def create_cone_mesh(radius, height, segments=32):
    """Create a cone mesh for cat ears"""
    h = height / 2
    vertices = [[0, 0, -h], [0, 0, h]]
    
    angles = np.linspace(0, 2*math.pi, segments, endpoint=False)
    for angle in angles:
        vertices.append([radius * math.cos(angle), radius * math.sin(angle), -h])
    
    vertices = np.array(vertices)
    
    faces = []
    for i in range(segments):
        next_i = (i+1) % segments
        faces.append([0, 2+i, 2+next_i])
        faces.append([1, 2+next_i, 2+i])
    
    faces = np.array(faces)
    m = mesh.Mesh(np.zeros(len(faces), dtype=mesh.Mesh.dtype))
    for i, face in enumerate(faces):
        m.vectors[i] = vertices[face]
    return m

def create_sphere_mesh(radius, segments=32):
    """Create a sphere mesh usingicosphere-like approach"""
    # Create vertices using spherical coordinates
    vertices = []
    
    # North pole
    vertices.append([0, 0, radius])
    # South pole
    vertices.append([0, 0, -radius])
    
    # Middle rings
    for i in range(1, segments):
        phi = i * math.pi / segments
        z = radius * math.cos(phi)
        r = radius * math.sin(phi)
        for j in range(segments):
            theta = j * 2 * math.pi / segments
            x = r * math.cos(theta)
            y = r * math.sin(theta)
            vertices.append([x, y, z])
    
    vertices = np.array(vertices)
    n = len(vertices)
    
    # Create faces
    faces = []
    
    # North pole faces (triangles to ring1)
    ring1_start = 2
    for j in range(segments):
        next_j = (j+1) % segments
        faces.append([0, ring1_start + j, ring1_start + next_j])
    
    # Middle faces (quads split into triangles)
    for i in range(1, segments-1):
        ring_curr = 2 + (i-1) * segments
        ring_next = 2 + i * segments
        for j in range(segments):
            next_j = (j+1) % segments
            # Two triangles per quad
            faces.append([ring_curr + j, ring_next + j, ring_curr + next_j])
            faces.append([ring_curr + next_j, ring_next + j, ring_next + next_j])
    
    # South pole faces
    ring_last_start = 2 + (segments-2) * segments
    for j in range(segments):
        next_j = (j+1) % segments
        faces.append([1, ring_last_start + next_j, ring_last_start + j])
    
    faces = np.array(faces)
    
    # Check for valid faces
    valid_faces = []
    for f in faces:
        if all(idx < len(vertices) for idx in f):
            valid_faces.append(f)
    
    faces = np.array(valid_faces)
    m = mesh.Mesh(np.zeros(len(faces), dtype=mesh.Mesh.dtype))
    for i, face in enumerate(faces):
        m.vectors[i] = vertices[face]
    return m

def save_stl(mesh_obj, filename):
    """Save mesh to STL file"""
    path = output_dir + filename
    mesh_obj.save(path)
    size_kb = os.path.getsize(path) / 1024
    print(f"  ✓ Saved: {filename} ({size_kb:.1f} KB)")
    return path

print("=" * 60)
print("PERCY UNIT v1 - GENERATING DETAILED STL FILES")
print("=" * 60)

# 1. CHEST PLATE
print("\n[1/6] Chest Plate...")
chest = create_box_mesh(80, 90, 15)
save_stl(chest, "chest-plate.stl")

# 2. CAT EARS
print("\n[2/6] Cat Ears (x2)...")
left_ear = create_cone_mesh(15, 40, 32)
save_stl(left_ear, "cat-ear-left.stl")
right_ear = create_cone_mesh(15, 40, 32)
save_stl(right_ear, "cat-ear-right.stl")

# 3. LIGHTNING BOLT
print("\n[3/6] Lightning Bolt Emblem...")
bolt = create_box_mesh(25, 60, 8)
save_stl(bolt, "lightning-bolt.stl")

# 4. SHOULDER PADS
print("\n[4/6] Shoulder Pads (x2)...")
left_pad = create_box_mesh(50, 35, 20)
save_stl(left_pad, "shoulder-pad-left.stl")
right_pad = create_box_mesh(50, 35, 20)
save_stl(right_pad, "shoulder-pad-right.stl")

# 5. HEAD (sphere)
print("\n[5/6] Head Module...")
head = create_sphere_mesh(35, 24)
save_stl(head, "head.stl")

# 6. NECK
print("\n[6/6] Neck Module...")
neck = create_cylinder_mesh(15, 25, 32)
save_stl(neck, "neck.stl")

# BONUS PARTS
print("\n[BONUS] Legs + Arms...")
upper_leg = create_cylinder_mesh(15, 60, 32)
save_stl(upper_leg, "upper-leg-left.stl")
lower_leg = create_cylinder_mesh(12, 55, 32)
save_stl(lower_leg, "lower-leg-left.stl")
foot = create_box_mesh(50, 40, 10)
save_stl(foot, "foot.stl")
upper_arm = create_cylinder_mesh(12, 55, 32)
save_stl(upper_arm, "upper-arm-left.stl")
lower_arm = create_cylinder_mesh(10, 50, 32)
save_stl(lower_arm, "lower-arm-left.stl")
hand = create_box_mesh(35, 45, 15)
save_stl(hand, "hand.stl")

print("\n" + "=" * 60)
print("ALL STL FILES GENERATED!")
print("=" * 60)
print("""
All files saved to: /home/chris/.openclaw/workspace/percy-robot/
Ready for download and3D printing!
""")