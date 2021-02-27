function [hub_areas,connections,angles] = areafun(hubs)
    no_hubs = size(hubs,1);
    connections = zeros(no_hubs,5);
    connections(:,1:2) = hubs(:,1:2);
    for i = 1:no_hubs
        x0 = 1e6;
        for j = 1:no_hubs
            if i == j
                continue
            end
            temp = distance(connections(i,1:2),hubs(j,1:2));
            if temp<x0
                x0 = temp;
                connections(i,3:4) = hubs(j,1:2);
                connections(i,5) = x0;
            end
        end
    end
    angles = zeros(no_hubs,1);
    for i = 1:no_hubs
        angles(i) = asin((connections(i,4)-connections(i,2))/distance(connections(i,1:2),connections(i,3:4)));
        if connections(i,3)<connections(i,1)
            if connections(i,4)<connections(i,2)
                angles(i) = 1.5*pi-angles(i);
            else
                angles(i) = pi-angles(i);
            end
        end
    end
    hub_areas = zeros(no_hubs,8);
    p = cell(4,1);
    for i = 1:no_hubs 
        long = 2*hubs(i,3);
        short = hubs(i,4)/long;
        p{1} = [0 0];
        theta = 0+angles(i); 
        p{2} = long*[cos(theta) sin(theta)];
        theta = atan(short/long)+angles(i);
        p{3} = distance(p{1},[long short])*[cos(theta) sin(theta)];
        theta = 0.5*pi+angles(i);
        p{4} = short*[cos(theta) sin(theta)];
        mid = [hubs(i,1) hubs(i,2)]-mean(cell2mat(p));
        hub_areas(i,:) = cell2mat(transpose(p))+[mid,mid,mid,mid];
    end
end