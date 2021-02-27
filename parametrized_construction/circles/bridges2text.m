lvls = 1;
hub_areas = cell(lvls,1);
bridged_connections = cell(lvls,1);
no_hubs = [8,3,1];
dims = [50,50];
minsize = 4;
randrange = 4;

for lvl = 1:lvls
    filename = append('coordinates_lv',num2str(lvl-1),'.txt');
    file = fopen(filename,'w');
    [hub_areas{lvl},bridged_connections{lvl}] = bridgefun(no_hubs(lvl),dims,minsize,randrange);
    for i = 1:no_hubs(lvl)
    fprintf(file,'%g,%g,%g,%g,%g,%g,%g,%g\n',hub_areas{lvl}(i,1:8));
    end
    for i = 1:size(bridged_connections{lvl},1)
        fprintf(file,'%g,%g,%g,%g,%g,%g,%g,%g\n',bridged_connections{lvl}(i,1:8));
    end
    fclose(file);
end


