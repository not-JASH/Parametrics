no_areas = 3;

areas{1} = new_area([],[]);
areas{2} = new_area(areas{1},ceil(4*rand(1)));
for i = 3:no_areas
    new_connection = ceil(4*rand(1));
    if new_connection == areas{i-1}.connection
        new_connection = new_connection+1;
        new_connection(new_connection>4)=1;
    end
    areas{i} = new_area(areas{i-1},new_connection);
end

figure
hold on 
for i = 1:no_areas
    patch(areas{i}.corners(:,1),areas{i}.corners(:,2),randcolor)
end

function rgb = randcolor
    rgb = rand(1,3);
    while all(rgb<0.1)
        rgb = rand(1,3);
    end
end



function Area = new_area(parent_area,connection)
    Area = area;
    width = 2 + 8*rand(1);
    length = 2 + 8*rand(1);
    corners = [0,0;0,length;width,length;width,0];
    if not(isempty(parent_area))
        switch connection 
            case 1 
                keypoints = parent_area.corners(2:3,:);
                Area.connection = 3;
            case 2 
                keypoints = parent_area.corners(3:4,:);
                Area.connection = 4;
            case 3 
                keypoints = [parent_area.corners(4,:);parent_area.corners(1,:)];
                corners(:,2) = -corners(:,2);
                Area.connection = 1;
            case 4 
                keypoints = parent_area.corners(1:2);
                Area.connection = 2;
                corners = -corners;
        end
        translation = 0.5*sum(keypoints);
    else 
        translation = [0,0];
    end
    Area.corners = corners+translation;
end
    
    