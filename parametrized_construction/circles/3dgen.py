projectdir = "C:\project_data\parametrized_construction\circles"
from os.path import join 
from os import getcwd as pwd, chdir as cd
cd(projectdir)
from numpy.random import rand
from numpy import array,zeros
import sys,bpy,csv,bmesh
from importlib import reload
sys.path.append(".")
from classes import vertsurf,horsurf,room
modules2reload = [vertsurf,horsurf,room]
#from circles import circlefun,areafun,bridgefun


std_height = 3
corners = zeros((4,3))
rooms = []
lvls = 2

for levels in range(lvls):
    filename = join(projectdir,'coordinates_lv'+str(levels)+'.txt')
    vshift = levels*std_height
    print(vshift)
    file = open(filename,'r')
    nolines = 1
    for line in file: 
        temp = line.split(",")
        for i in range(4):
            corners[i,[0,1]] = array([float(temp[2*i]),float(temp[2*i+1])])
        newroom = room(corners,std_height,'level'+str(levels+1)+'_room'+str(nolines)+'_')
        newroom.show(h=vshift)
        nolines +=1
    #rooms.append(newroom)
    file.close()

'''
for obj in bpy.data.objects:
    print(obj.name)
'''

wallthick = 0.1

for obj in bpy.context.scene.objects:
    print(obj.name)
    #bpy.context.scene.objects.active = obj
    bpy.context.view_layer.objects.active = obj

    # Go to edit mode, face selection mode and select all faces
    bpy.ops.object.mode_set( mode = 'EDIT' )     # Toggle edit mode
    bpy.ops.mesh.select_mode( type = 'FACE' )    # Change to face selection
    bpy.ops.mesh.select_all( action = 'SELECT' ) # Select all faces

    # Create Bmesh
    bm = bmesh.new()
    bm = bmesh.from_edit_mesh( bpy.context.object.data )

    # Extude Bmesh
    for f in bm.faces:
        face = f.normal
    r = bmesh.ops.extrude_face_region(bm, geom=bm.faces[:])
    verts = [e for e in r['geom'] if isinstance(e, bmesh.types.BMVert)]
    TranslateDirection = face * wallthick # Extrude Strength/Length
    bmesh.ops.translate(bm, vec = TranslateDirection, verts=verts)

    # Update & Destroy Bmesh
    bmesh.update_edit_mesh(bpy.context.object.data) # Write the bmesh back to the mesh
    bm.free()  # free and prevent further access

    # Flip normals
    bpy.ops.mesh.select_all( action = 'SELECT' )
    bpy.ops.mesh.flip_normals() 

    # At end recalculate UV
    bpy.ops.mesh.select_all( action = 'SELECT' )
    bpy.ops.uv.smart_project()

    # Switch back to Object at end
    bpy.ops.object.mode_set( mode = 'OBJECT' )

    # Origin to center
    bpy.ops.object.origin_set(type='ORIGIN_GEOMETRY', center='BOUNDS')



