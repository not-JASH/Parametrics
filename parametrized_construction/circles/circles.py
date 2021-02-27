from numpy.random import rand
from numpy import argsort,flip,zeros,concatenate,array,mean,unique,degrees
from math import sqrt,asin,atan,atan2,sin,cos,pi

def distance(p1,p2):
    dx = p2[0]-p1[0]
    dy = p2[1]-p1[1]
    dist = sqrt(dx**2 + dy**2)
    return dist

def clockwisesort(points):
    midpoint = mean(points,axis=0)
    angles = zeros((points.shape[0],1))
    for i in range(points.shape[0]):
        angles[i] = degrees(atan2((points[i,1]-midpoint[1]),(points[i,0]-midpoint[0])))
    index = argsort(angles[:,0])
    points = points[index,:]
    return index,points

def circlefun(params):
    hubs = array([params[2],params[3],params[0]])*rand(int(params[4]),3)
    hubs[:,2] += params[1]
    order = flip(argsort(hubs[:,2]+params[1]))
    hubs = hubs[order,:]
    n = 0
    while n < params[4]:
        m = 0
        while m < params[4]:
            if m == n:
                m += 1
                continue
            dy = hubs[n,1]-hubs[m,1]
            dx = hubs[n,0]-hubs[m,0]
            delta = sqrt(dx**2 + dy**2)
            if delta <= hubs[n,2]+hubs[m,2]:
                theta = asin(dy/delta)
                delta = hubs[n,2]+hubs[m,2]
                hubs[m,0] = hubs[m,0]+delta*cos(theta)
                hubs[m,1] = hubs[m,1]+delta*sin(theta)
                n = 0
                m = 0
            else:
                m+=1
        n += 1
    hubs = concatenate((hubs,zeros((int(params[4]),1))),axis=1)
    hubs[:,3] = pi*(hubs[:,2]**2)
    center = array([sum(hubs[:,0]*hubs[:,3])/sum(hubs[:,3]),sum(hubs[:,0]*hubs[:,3])/sum(hubs[:,3])])
    hubs = concatenate((hubs,zeros((int(params[4]),1))),axis=1)
    for i in range(int(params[4])):
        hubs[i,4] = sqrt((hubs[i,0]-center[0])**2 + (hubs[i,1]-center[1])**2)
    order = argsort(hubs[:,4])
    hubs = hubs[order,:]
    return hubs,center

def areafun(hubs):
    no_hubs = hubs.shape[0]
    connections = zeros((no_hubs,5))
    connections[:,[0,1]] = hubs[:,[0,1]]
    for i in range(no_hubs):
        x0 = 1e6
        for j in range(no_hubs):
            if i == j:
                continue
            temp = distance(connections[i,[0,1]],hubs[j,[0,1]])
            if temp<x0:
                x0 = temp
                connections[i,[2,3]] = hubs[j,[0,1]]
                connections[i,4] = x0
    angles = zeros((no_hubs,1))
    for i in range(no_hubs):
        angles[i] = asin((connections[i,3]-connections[i,1])/distance(connections[i,[0,1]],connections[i,[2,3]]))
        if connections[i,2]<connections[i,0]:
            if connections[i,3]<connections[i,1]:
                angles[i] = 1.5*pi - angles[i]
            else:
                angles[i] = pi - angles[i]
    hub_areas = zeros((no_hubs,8))
    for i in range(no_hubs):
        long = 2*hubs[i,2]
        short = hubs[i,3]/long
        p1 = array([0,0])
        theta = 0+angles[i]
        p2 = long*array([cos(theta),sin(theta)])
        theta = atan(short/long)+angles[i]
        p3 = distance(p1,array([short,long]))*array([cos(theta),sin(theta)])
        theta = 0.5*pi + angles[i]
        p4 = short*array([cos(theta),sin(theta)])
        mid = hubs[i,[1,2]] - array([0.25*(p1[0]+p2[0]+p3[0]+p4[0]),0.25*(p1[1]+p2[1]+p3[1]+p4[1])])
        hub_areas[i,:] = concatenate([p1+mid,p2+mid,p3+mid,p4+mid])
    return hub_areas,connections,angles

def bridgefun(hubs,hub_areas,connections):
    no_hubs = hub_areas.shape[0]
    points = zeros((4,3))
    uniq = unique(connections[:,4],return_index=True)[1]
    no_bridges = len(uniq)
    bridged_connections = zeros((no_bridges,8))
    points = zeros((4,3))

    for i in range(no_bridges):
        midpoint = mean(array([connections[uniq[i],[0,1]],connections[uniq[i],[2,3]]]),axis=0)
        for j in range(4):
            points[j,[0,1]] = hub_areas[uniq[i],[2*j,2*j+1]]
            points[j,2] = distance(points[j,[0,1]],midpoint)
        order = argsort(points[:,2])
        points = points[order,:]
        for j in range(2):
            bridged_connections[i,[2*j,2*j+1]] = points[j,[0,1]]
        for k in range(no_hubs):
            if (hubs[k,[0,1]]==connections[uniq[i],[2,3]]).all():
                break
        for j in range(4):
            points[j,[0,1]] = hub_areas[k,[2*j,2*j+1]]
            points[j,2] = distance(points[j,[1,2]],midpoint)
        order = argsort(points[:,2])
        points = points[order,:]
        for j in range(2):
            k = j+2
            bridged_connections[i,[2*k,2*k+1]] = points[j,[1,2]]
        temp = zeros((4,2))
        for j in range(4):
            temp[j,:] = bridged_connections[i,[2*j,2*j+1]]
        temp = clockwisesort(temp)[1]
        for j in range(4):
            bridged_connections[i,[2*j,2*j+1]] = temp[j,:]
    return bridged_connections
    
    
