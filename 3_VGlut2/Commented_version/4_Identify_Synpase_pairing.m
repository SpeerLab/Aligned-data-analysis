%After the add_to code, paired Vglut2 was found in a very simple way. Since
%we used paired Bassoon (red) clusters, it's not necessary to calculate the
%shell_area vs. distance. Any Vglut2 clusters having nearby Bassoon will be
%considered true signals. 

%Bse_folder is the Vglut2 output folder. ANd outpath2 is the synapse output
%folder. 
base_folder = 'Z:\Chenghang\7.1.20.WT_P2_C_A\analysis\Result\3_Vglut2\';
outpath = base_folder;
outpath2 = 'Z:\Chenghang\7.1.20.WT_P2_C_A\analysis\Result\';
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

%%
%Results saved as statsVwater_ss in V_paired.mat. 
save([base_folder 'V_paired.mat'],'statsVwater_ss','statsVwater_sn');

