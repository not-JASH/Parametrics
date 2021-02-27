function [hubs,center] = circlefun(params)
%%
% params are [randrange,minradius,xplot,yplot,no_hubs]
% output is in [x y r area distance2center]

%%
    hubs = [params(3),params(4),params(1)].*rand(params(5),3);
    hubs(:,3) = hubs(:,3)+params(2);
    [~,order] = sort(hubs(:,3),'descend');
    hubs = hubs(order,:);
    n = 1;
    while n <= params(5) 
        m = 1;
        while m <= params(5) 
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
    hubs = [hubs,zeros(params(5),1)];
    hubs(:,4) = pi*power(hubs(:,3),2);
    center = [sum(hubs(:,1).*hubs(:,4))/sum(hubs(:,4)),sum(hubs(:,2).*hubs(:,4))/sum(hubs(:,4))];
    hubs = [hubs,zeros(params(5),1)];
    hubs(:,5) = sqrt(power(hubs(:,1)-center(1),2)+power(hubs(:,2)-center(2),2));
    [~,order] = sort(hubs(:,5),'ascend');
    hubs = hubs(order,:);
    %[x y r area distance2center]

end