%%
clear;
clc

exp_folder = 'Z:\Chenghang\12.21.2020_P8EA_A\';
V_Result_folder = [exp_folder 'analysis\Result\3_VGlut2\'];
S_Result_folder = [exp_folder 'analysis\Result\5_V_Syn\'];
im_folder = [exp_folder 'analysis\elastic_align\conv_488\'];

outpath = [exp_folder 'analysis\Result\4_CTB\'];

load([V_Result_folder 'V_paired.mat']);
load([S_Result_folder 'R_paired_3.mat']);
load([S_Result_folder 'G_paired_3.mat']);
A = imread([im_folder '027.tif']);
%
centG = zeros(numel(statsGwater_ssss),3);
centR = zeros(numel(statsRwater_ssss),3);
centV = zeros(numel(statsVwater_ss),3);
for i = 1:numel(statsGwater_ssss)
    centG(i,:) = statsGwater_ssss(i).WeightedCentroid;
end
for i = 1:numel(statsRwater_ssss)
    centR(i,:) = statsRwater_ssss(i).WeightedCentroid;
end
for i = 1:numel(statsVwater_ss)
    centV(i,:) = statsVwater_ss(i).WeightedCentroid;
end
centG = centG(:,1:2);
centR = centR(:,1:2);
centV = centV(:,1:2);
%%
figure;
imshow(A);

% manually draw polygon on figure
currpoly=impoly
% return polygon coordinates
synapse_regiong=currpoly.getPosition
%
% save figure of selected polygon region
savefig([outpath 'ipsi_selection_poly.fig'])
%
%Return centroid and stats lists for all clusters in selected polygon area
statsGwater_ssss_in = statsGwater_ssss(find(inpolygon(centG(:,1),centG(:,2),synapse_regiong(:,1),...
    synapse_regiong(:,2))));

statsGwater_ssss_out = statsGwater_ssss(find(~inpolygon(centG(:,1),centG(:,2),synapse_regiong(:,1),...
    synapse_regiong(:,2))));

statsRwater_ssss_in = statsRwater_ssss(find(inpolygon(centR(:,1),centR(:,2),synapse_regiong(:,1),...
    synapse_regiong(:,2))));

statsRwater_ssss_out = statsRwater_ssss(find(~inpolygon(centR(:,1),centR(:,2),synapse_regiong(:,1),...
    synapse_regiong(:,2))));

statsVwater_ss_in = statsVwater_ss(find(inpolygon(centV(:,1),centV(:,2),synapse_regiong(:,1),...
    synapse_regiong(:,2))));

statsVwater_ss_out = statsVwater_ss(find(~inpolygon(centV(:,1),centV(:,2),synapse_regiong(:,1),...
    synapse_regiong(:,2))));

numel(statsGwater_ssss_in)
numel(statsGwater_ssss_out)
numel(statsRwater_ssss_in)
numel(statsRwater_ssss_out)
numel(statsVwater_ss_in)
numel(statsVwater_ss_out)
%%
save([outpath 'split_cluster.mat'],'statsGwater_ssss_in','statsGwater_ssss_out','statsRwater_ssss_in','statsRwater_ssss_out','statsVwater_ss_in','statsVwater_ss_out');