%%
%purpose of this file: 
%1. find paired clusters and store in statsLwater
%2. make sure each statsLwater have at lest 2 clusters. 
%3. Delete statsLwater if there are too many clusters paired (>6)
clear;clc
%
exp_folder = 'X:\Chenghang\OPN4_SCN\OPN4_SCN_Het_P60_A\';
base_folder = [exp_folder '\analysis\Result\'];
outpath = base_folder;

load([outpath 'G_paired_2'])
load([outpath 'R_paired_2'])
%
%statsLwater is the stats sturcure for large cluster, G and R contains the
%order of G and R clusters included in this large paired cluster. 
statsLwater.G = [];
statsLwater.R = [];
%
all_G = zeros(20,numel(statsGwater_sss));
all_R = zeros(20,numel(statsRwater_sss));
for i =1:numel(statsGwater_sss)
    len = numel(statsGwater_sss(i).paired_order);
    all_G(1:len,i) = statsGwater_sss(i).paired_order;
end

for i =1:numel(statsRwater_sss)
    len = numel(statsRwater_sss(i).paired_order);
    all_R(1:len,i) = statsRwater_sss(i).paired_order;
end
%
order = 1;
G_exist = zeros(numel(statsGwater_sss),1);
for i =1:numel(statsGwater_sss)
    disp(i)
    if G_exist(i) <1
        G_exist(i) = 1;
        [listG,listR] = update(i,all_G,all_R);
        statsLwater(order).G = listG;
        statsLwater(order).R = listR;
        order = order + 1;
        for i =1:numel(listG)
            G_exist(listG(i)) = 1;
        end
    end
end
for i = 1:numel(statsLwater)
    a = 0;
    a = a + numel(statsLwater(i).G);
    a = a + numel(statsLwater(i).R);
    statsLwater(i).num = a;
end

%
%delete cluster with more than 10 small clusters
need_to_delete = zeros(numel(statsLwater,1));
for i = 1:numel(statsLwater)
    if (statsLwater(i).num > 6.2 | statsLwater(i).num < 2)
        need_to_delete(i) = 1;
    end
end
statsLwater(find(need_to_delete)) = [];
%
%New statsG and statsR
order_G = 1;
order_R = 1;
statsGwater = statsGwater_sss;
statsRwater = statsRwater_sss;
statsGwater = statsGwater(1);
statsRwater  = statsRwater(1);
for i =1:numel(statsLwater)
    disp(i)
    for j = 1:numel(statsLwater(i).G)
        statsGwater(order_G) = statsGwater_sss(statsLwater(i).G(j));
        order_G = order_G + 1;
    end
    for j = 1:numel(statsLwater(i).R)
        statsRwater(order_R) = statsRwater_sss(statsLwater(i).R(j));
        order_R = order_R + 1;
    end
end
%
% G_Area = [];
% for i = 1:numel(statsLwater)
%     G_Area(i) = 0;
%     for j = 1:numel(statsLwater(i).R)
%         G_Area(i) = G_Area(i) + statsGwater_sss(statsLwater(i).R(j)).Area;
%     end
% end
% %%
% list = [statsGwater.Area];
% list = log(list.*0.0155.*0.0155.*0.07);
% std(list)
% list = [statsRwater.Area];
% list = log(list.*0.0155.*0.0155.*0.07);
% std(list)
%
save([outpath 'statsLwater.mat'],'statsLwater','statsGwater','statsRwater');
statsGwater_sss = statsGwater;
statsRwater_sss = statsRwater;
save([outpath 'G_paired_2.mat'],'statsGwater_sss')
save([outpath 'R_paired_2.mat'],'statsRwater_sss')
disp("data saved")
%%
save_path = 'C:\Users\Chenghang\Desktop\Data\OPN4\Het_R_A\';
temp = [statsGwater_sss.Volume1_0];
temp = temp';
save([save_path 'statsGwater_sss.Area.txt'],'temp','-ascii','-double');
temp = [statsGwater_sss.TintsG];
temp = temp';
save([save_path 'statsGwater_sss.TintsG.txt'],'temp','-ascii','-double');
temp = [statsRwater_sss.Volume1_0];
temp = temp';
save([save_path 'statsRwater_sss.Area.txt'],'temp','-ascii','-double');
temp = [statsRwater_sss.TintsG];
temp = temp';
save([save_path 'statsRwater_sss.TintsG.txt'],'temp','-ascii','-double');
%%
%utility functions.
%Find the large cluster
function [listG,listR] = update(num,all_G,all_R)
%%
    listG = [];
    listR = [];
    listG = cat(1,listG,num);
    listG = unique(listG);
    listR = cat(1,listR,all_G(:,num));
    listR = unique(listR);
    listR = listR(find(listR));

    for i = 1:20
        listG = single_update(listR,listG,all_R);
        listR = single_update(listG,listR,all_G);
    end
end
%
function list_new = single_update(list_source,list_target,list_source_all)
    list_target_temp = list_target;
    for i = 1:numel(list_source)
        list_target_temp = cat(1,list_target_temp,list_source_all(:,list_source(i)));
    end
    list_new = unique(list_target_temp);
    list_new = list_new(find(list_new));
end
