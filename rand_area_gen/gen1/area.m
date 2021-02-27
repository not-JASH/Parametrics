classdef area
    % corners are arranged in a clockwise manner, starting from bottom
    % left
    % 2 3 
    % 1 4 
    % parent area is the area before the current. 
    % possible values are 1,2,3,4 corresponding to N,E,S,W
    %(top,right,bottom,left)
    properties 
        corners = zeros(4,2);
        connection 
    end
end

