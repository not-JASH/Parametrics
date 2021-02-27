sf = 10;
no_points =9;
points = rand(no_points,2);

scatter(points(:,1),points(:,2))

distances = zeros(no_points);
for i = 1:no_points 
    for j = 1:no_points
        distances(i,j) = distance(points(i,:),points(j,:));
    end
end
distances = tril(distances);distances(distances==0)=nan;
closestpoint = zeros(no_points,1);
for i = 1:no_points
    [~,closestpoint(i)]=min(distances(:,i));
end

hold on 
for i = 1:no_points 
    x = [points(i,1),points(closestpoint(i),1)];
    y = [points(i,2),points(closestpoint(i),2)];
    plot(x,y)
end
hold off













































function D = distance(p1,p2)
    D = sqrt(power(p2(2)-p1(2),2)+power(p2(1)-p1(1),2));
end