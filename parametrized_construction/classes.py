from math import sin,cos
from numpy import add,subtract
import bpy

class vertsurf:
    '''
    define surface by the vertical plane inbetween two points (0,0,0) and (x,y,z)
    '''
    def __init__(self,defp,name):
        self.verts = []
        self.faces = []  
        self.verts.append([0,0,0])
        self.verts.append([defp[0],defp[1],0])
        self.verts.append([defp[0],defp[1],defp[2]])
        self.verts.append([0,0,defp[2]])
        self.faces.append([0,1,2,3])
        self.name = name

class horsurf:    
    '''
    define surface by its corners
    '''
    def __init__(self,corners,name):
        self.verts = corners
        self.faces = []
        self.faces.append([0,1,2,3])
        self.name = name
        
class room:
    '''
    room defined by a point, a scaling factor and relative dimensions
    dimensions are a 2x3 array : [relative_length,angle]x3corners
    relative_length is walllength/scalingfactor
    angle is the angle the wall makes with the previous wall
    all walls have the same height for now
    '''
    def __init__(self,startpoint,sf,dims,height):
        self.height = height
        self.corners = []
        self.walls = []
        self.floor = []
        self.ceiling = []
        current_angle = 0
        self.corners.append(startpoint)
        for i in range(3):
            point = self.corners[i]
            current_angle = current_angle+dims[i,1]
            dx = dims[i,0]*sf*cos(current_angle*3.14159)
            dy = dims[i,0]*sf*sin(current_angle*3.14159)
            self.corners.append(add(point,[dx,dy,0]))
        for i in range(4):
            sp = i
            ep = i+1
            if ep>3:
                ep = 0
            walldef = subtract(self.corners[ep],self.corners[sp])
            walldef = add(walldef,[0,0,height])
            self.walls.append(vertsurf(walldef,'wall_'+str(i+1)))
        self.floor = horsurf(self.corners,'floor')
        self.ceiling = horsurf(self.corners,'ceiling')
            
    def addtoscene(self,feature,start_point):
        mesh = bpy.data.meshes.new(feature.name)
        object = bpy.data.objects.new(feature.name,mesh)
        object.location = start_point
        bpy.context.collection.objects.link(object)
        mesh.from_pydata(feature.verts,[],feature.faces)
        mesh.update(calc_edges=True)
        #object.data.materials.append(feature.material)
        
    def show(self):
        start_point = self.corners[0]
        for i in range(4):
            self.addtoscene(self.walls[i],self.corners[i])
        self.addtoscene(self.floor,[0,0,0])
        self.addtoscene(self.ceiling,[0,0,self.height])
            
        

