classdef rec_cluster 
    properties 
        rectangles 
        no_rectangles
        dimension_range
    end
    
    methods        
        function obj = rec_cluster(dim_range,no_rectangles)
            obj.no_rectangles = no_rectangles;
            obj.rectangles = cell(no_rectangles,1);
            obj.dimension_range = dim_range;
            
            up = 0.5*(dim_range(1)+dim_range(2)*rand(1));
            right = 0.5*(dim_range(1)+dim_range(2)*rand(1));
            down = 0.5*(dim_range(1)+dim_range(2)*rand(1));
            left = 0.5*(dim_range(1)+dim_range(2)*rand(1));
            obj.rectangles{1} = rectangle_area(up,right,down,left);
            obj.dimension_range = [up,right,down,left];
            new_rectangle = 2;
            last_rectangle = 1;
            while isempty(obj.rectangles{end})
                fprintf('%g %g\n',new_rectangle,last_rectangle)
                obj.rectangles{new_rectangle} = obj.rectangles{last_rectangle}.rand_adj(dim_range,dim_range);
                while 1
                    overlap = 0;
                    for i = 1:new_rectangle-1
                        if obj.rectangles{new_rectangle}.overlaps(obj.rectangles{i})
                            overlap = 1;
                        end
                    end
                    if overlap 
                        last_rectangle = ceil((new_rectangle-1)*rand(1));
                        obj.rectangles{new_rectangle} = obj.rectangles{last_rectangle}.rand_adj(dim_range,dim_range);
                    else 
                        last_rectangle = new_rectangle;
                        new_rectangle = new_rectangle+1;
                        break
                    end
                end
            end
                    
        end
    end
end