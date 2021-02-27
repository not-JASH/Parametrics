projectdir = "C:\project_data\parametrized_construction\circles"
from os import getcwd as pwd, chdir as cd
cd(projectdir)
from numpy.random import rand
from numpy import array
import sys#,bpy
sys.path.append(".")
from classes import vertsurf,horsurf,room
from circles import circlefun,areafun,bridgefun


no_hubs = 7
dims = [50,50]
minsize = 4.5
randrange = 4
params = array([randrange,minsize,dims[0],dims[1],no_hubs])

hubs,center = circlefun(params)
hub_areas,connections,angles = areafun(hubs)
bridged_connections = bridgefun(hubs,hub_areas,connections)
