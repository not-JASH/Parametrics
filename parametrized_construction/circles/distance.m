function dist = distance(p1,p2)
    dx = p2(1)-p1(1);
    dy = p2(2)-p1(2);
    dist = sqrt(power(dx,2)+power(dy,2));
end