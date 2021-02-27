import bpy
from numpy import array

class vertsurf:
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
    def __init__(self,corners,height,name):
        self.name = name
        self.height = height
        self.corners = corners
        self.walls = []
        self.floor = []
        self.ceiling = []
        for i in range(4):
            sp = i
            ep = i+1
            if ep>3:
                ep = 0
            walldef = self.corners[ep]-self.corners[sp]
            walldef = walldef+[0,0,height]
            self.walls.append(vertsurf(walldef,name+'wall_'+str(i+1)))
        self.floor = horsurf(self.corners,name+'floor')
        self.ceiling = horsurf(self.corners,name+'ceiling')

    def addtoscene(self,feature,start_point):
        mesh = bpy.data.meshes.new(feature.name)
        object = bpy.data.objects.new(feature.name,mesh)
        object.location = start_point
        bpy.context.collection.objects.link(object)
        mesh.from_pydata(feature.verts,[],feature.faces)
        mesh.update(calc_edges=True)
        #object.data.materials.append(feature.material)
        
    def show(self,h=0):
        vert_shift = array([0,0,h])
        for i in range(4):
            self.addtoscene(self.walls[i],self.corners[i]+vert_shift)
        self.addtoscene(self.floor,[0,0,0]+vert_shift)
        self.addtoscene(self.ceiling,[0,0,self.height]+vert_shift)
            
