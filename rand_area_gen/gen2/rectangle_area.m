classdef rectangle_area
    properties 
        available_connections = [1,1,1,1];
        le_lim
        up_lim
        ri_lim
        lo_lim
        corners
    end
    
    methods 
        function obj = rectangle_area(up,right,down,left)
            obj.le_lim = left;
            obj.up_lim = up;
            obj.ri_lim = right;
            obj.lo_lim = down;
            obj.corners = [left,up;right,up;right,down;left,down];
        end
        
        function new_area = rand_adj(obj,w_range,l_range)
            face = ceil(4*rand(1));
            while ~obj.available_connections(face)
                face = face+1;
                face(face>4)=1;
            end
            new_width = w_range(1)+w_range(2)*rand(1);
            new_length = l_range(1)+l_range(2)*rand(1);
            %length is in y, width is x 
            switch face
                case 1 %connection is upper face
                    connection = 0.5*(obj.le_lim+obj.ri_lim);
                    up = obj.up_lim + new_length;
                    right = connection + 0.5*new_width;
                    down = obj.up_lim;
                    left = connection-0.5*new_width;
                    new_area = rectangle_area(up,right,down,left);
                    new_area.available_connections(3) = 0;
                case 2 %connection is right face
                    connection = 0.5*(obj.up_lim+obj.lo_lim);
                    up = connection + 0.5*new_length;
                    right = obj.ri_lim+new_width;
                    down = connection - 0.5*new_length;
                    left = obj.ri_lim;
                    new_area = rectangle_area(up,right,down,left);
                    new_area.available_connections(4) = 0;
                case 3 %connection is down face
                    connection = 0.5*(obj.le_lim+obj.ri_lim);
                    up = obj.lo_lim;
                    right = connection + 0.5*new_width;
                    down = obj.lo_lim - new_length;
                    left = connection - 0.5*new_width;
                    new_area = rectangle_area(up,right,down,left);
                    new_area.available_connections(1) = 0;
                case 4 % connection is left face
                    connection = 0.5*(obj.up_lim+obj.lo_lim);
                    up = connection + 0.5*new_length;
                    right = obj.le_lim;
                    down = connection - 0.5*new_length;
                    left = obj.le_lim - new_width;
                    new_area = rectangle_area(up,right,down,left);
                    new_area.available_connections(2) = 0;
            end
        end
        
        function state = contains_point(obj,point)
            state = 0;
            if obj.le_lim < point(1) && obj.ri_lim > point(1)
                if obj.lo_lim < point(2) && obj.up_lim > point(2)
                    state = 1;
                end
            end
        end
        
        function state = overlaps(obj,rectangle)
            % this is not an accurate measure of overlap!
            state = zeros(4,1);
            for i = 1:4
                state(i) = obj.contains_point(rectangle.corners(i,:));
            end
            state = any(state);
        end
    end            
end