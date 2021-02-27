function [points,index] = clockwisesort(points)
    midpoint = mean(points);
    angles = atan2d((points(:,2)-midpoint(2)),(points(:,1)-midpoint(1)));
    [~,index] = sort(angles);
    points = points(index,:);
end