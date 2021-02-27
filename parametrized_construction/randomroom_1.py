projectdir = "C:\project_data\parametrized_construction"
from os import getcwd as pwd, chdir as cd
cd(projectdir)
from numpy.random import rand
import sys,bpy

sys.path.append(".")

from classes import vertsurf,horsurf,room


dims = rand(3,2)
sf = 2
height = 1.5

sample_room = room([0,0,0],sf,dims,height)
sample_room.show()