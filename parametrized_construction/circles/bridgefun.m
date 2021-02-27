function [hub_areas,bridged_connections,hubs,connections,center] = bridgefun(no_hubs,dims,minsize,randrange)
    params = [randrange,minsize,dims,no_hubs];
    [hubs,center] = circlefun(params);
    [hub_areas,connections,~] = areafun(hubs);

    [~,uniq] = unique(connections(:,5));
    no_bridges = length(uniq);
    bridged_connections = zeros(no_bridges,8);
    points = zeros(4,3);

    for i = 1:no_bridges
        midpoint = mean([connections(uniq(i),[1,3])',connections(uniq(i),[2,4])']);
        for j = 1:4
            points(j,1:2) = hub_areas(uniq(i),2*j-1:2*j);
            points(j,3) = distance(points(j,1:2),midpoint);
        end
        [~,I] = sort(points(:,3),'ascend');
        points = points(I,:);
        for j = 1:2 
            bridged_connections(i,2*j-1:2*j) = points(j,1:2);
        end  
        for k = 1:no_hubs
            if all(hubs(k,1:2)==connections(uniq(i),3:4))
                break;
            end
        end
        for j = 1:4
            points(j,1:2) = hub_areas(k,2*j-1:2*j);
            points(j,3) = distance(points(j,1:2),midpoint);
        end
        [~,I] = sort(points(:,3),'ascend');
        points = points(I,:);
        for j = 1:2
            k = j+2;
            bridged_connections(i,2*k-1:2*k) = points(j,1:2);
        end 
        temp = zeros(4,2);
        for j = 1:4
            temp(j,:) = bridged_connections(i,2*j-1:2*j);
        end
        temp = clockwisesort(temp);
        for j = 1:4
            bridged_connections(i,2*j-1:2*j) = temp(j,:);
        end
    end
end

