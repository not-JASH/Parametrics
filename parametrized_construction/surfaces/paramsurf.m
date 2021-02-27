%% define structure with points in 3space
structure = [0 0 0;0 0 1;0 1 0;0 1 1;1 0 0;1 0 1;1 1 0;1 1 1]-[0.5 0.5 0.5];


%% define shape with arbitrary parameters
tic
[x,y,z] = shape(1);
scatter3(x(:),y(:),z(:))
xline(0);yline(0);
view(2)
% ashape = alphaShape(gather(x(:)),gather(y(:)),gather(z(:)),1);
% plot(ashape,'linestyle','none')
toc





%solve for parameters with constraints



















function [x,y,z] = shape(r)
    npoints = 1e2;
    theta1 = gpuArray(repmat(linspace(0,2*pi,npoints),[npoints 1])');
    theta2 = gpuArray(repmat(linspace(0,2*pi,npoints),[npoints,1]));
    r = 4;
    x = (r+cos(4*theta2)).*sin(theta1).*cos(theta2)*cos(theta2);
    y = (r+cos(4*theta2)).*sin(theta1).*sin(theta2);
    z = r.*cos(theta1);
end