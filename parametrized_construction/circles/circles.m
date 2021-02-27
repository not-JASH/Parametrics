clear;clf
randrange = 2.5;
minrad = 4;
xplot = 50;
yplot = 50;
no_hubs = 7;

hubs = [xplot,yplot,randrange].*rand(no_hubs,3);
hubs(:,3) = hubs(:,3)+minrad;
[~,order] = sort(hubs(:,3),'descend');
hubs = hubs(order,:);

%%
for i = 1:no_hubs
    xmax = hubs(i,1)+hubs(i,3);
    if xmax>xplot
        hubs(i,1) = hubs(i,1)-(xmax-xplot+0.1);
    end
    ymax = hubs(i,2)+hubs(i,3);
    if ymax>yplot
        hubs(i,2) = hubs(i,2)-(ymax-yplot+0.1);
    end
    xmin = hubs(i,1)-hubs(i,3);
    if xmin < 0 
        hubs(i,1) = hubs(i,1)-xmin+0.1;
    end
    ymin = hubs(i,2)-hubs(i,3);
    if ymin < 0
        hubs(i,2) = hubs(i,2)-ymin+0.1;
    end
end 

%%
n = 1;
while n <= no_hubs 
    m = 1;
    while m <= no_hubs
        if m == n
            m = m+1;
            continue
        end
        dy = hubs(n,2)-hubs(m,2);
        dx = hubs(n,1)-hubs(m,1);
        delta = sqrt(power(dx,2)+power(dy,2));
        if delta <= hubs(n,3)+hubs(m,3)
            theta = asin(dy/delta);
            delta = hubs(n,3)+hubs(m,3);
            hubs(m,1) = hubs(m,1)+delta*cos(theta);
            hubs(m,2) = hubs(m,2)+delta*sin(theta);
            n = 1;m = 1;
        else
            m = m+1;
        end
    end
    n = n+1;
end        

%%
hubs = [hubs,zeros(no_hubs,1)];
hubs(:,4) = pi*power(hubs(:,3),2);
center = [sum(hubs(:,1).*hubs(:,4))/sum(hubs(:,4)),sum(hubs(:,2).*hubs(:,4))/sum(hubs(:,4))];

%%
hubs = [hubs,zeros(no_hubs,1)];
hubs(:,5) = sqrt(power(hubs(:,1)-center(1),2)+power(hubs(:,2)-center(2),2));
[~,order] = sort(hubs(:,5),'ascend');
hubs = hubs(order,:);


%%
viscircles(hubs(:,1:2),hubs(:,3))
hold on 
scatter(center(1),center(2))
hold off
