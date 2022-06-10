base = 'X:\Chenghang\OPN4_SCN\OPN4_SCN_KO_P8_R_B\';
base_folder = [base 'analysis\Result\3_Vglut2\'];
outpath = base_folder;
outpath2 = [base 'analysis\Result\'];
%
load([outpath2 'R_paired_2.mat']);
voxel = [15.5 15.5 70];

for i =1:numel(statsRwater_sss)
    volumeRs(i,1) = statsRwater_sss(i).Area;
end

%
load([base_folder 'statslistV2sw10.mat']);
load([base_folder 'statslistV2nsw10.mat']);

volumeGs = sizeshape_matGa2s(:,19);
%
load([base_folder 'add_to_statsVw10_edges.mat'],'tintsG_p140');
mints_g70s = (([tintsG_p140])./[volumeGs]');
%
pairedg_idx = find(mints_g70s);
disp('The number of filtered out suspected Vgltu2 cluster: ')
numel(pairedg_idx)/numel(mints_g70s)
%
load([outpath 'statsV2sw10.mat']);
statsVwater_ss = statsGa2s(pairedg_idx);
statsVwater_sn = statsGa2s(~pairedg_idx);
save([base_folder 'V_paired.mat'],'statsVwater_ss','statsVwater_sn');
%%
save_path = 'X:\Chenghang\OPN4_SCN\OPN4_SCN_KO_P8_R_B\';
temp = [statsVwater_ss.Volume1_0];
temp = temp';
save([save_path 'statsVwater_ss.Area.txt'],'temp','-ascii','-double');
temp = [statsVwater_ss.TintsG];
temp = temp';
save([save_path 'statsVwater_ss.TintsG.txt'],'temp','-ascii','-double');
