clear
sample = rec_cluster([2,8],10);

figure
for i = 1:sample.no_rectangles
    patch(sample.rectangles{i}.corners(:,1),sample.rectangles{i}.corners(:,2),randcolor);
end


function rgb = randcolor
    rgb = rand(1,3);
    while all(rgb<0.1)
        rgb = rand(1,3);
    end
end


% for i = 1:no_areas
%     patch(areas{i}.corners(:,1),areas{i}.corners(:,2),rand(1,3))
% end