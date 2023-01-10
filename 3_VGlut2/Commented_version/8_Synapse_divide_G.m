%%
%Another simple pairing. This should be run immediately after coed '7_XXX'
%and don't 'clear' since we are still using the same statsRwater. 
base_folder = 'Z:\Chenghang\7.1.20.WT_P2_C_A\analysis\Result\5_V_Syn\';
outpath = base_folder;
%
load([base_folder 'statsG2w10_edges_plus_Vglut2.mat']);
voxel = [15.5 15.5 70];
%In the '7_XXX' statsRwater is actually statsGwater. So make the name
%correct here. 
statsGwater = statsRwater;
for i =1:numel(statsGwater)
    volumeGs(i,1) = statsGwater(i).Area;
end

%
load([base_folder 'add_to_statsGw10_edges_Vglut2.mat'],'tintsG_p140');
mints_g70s = (([tintsG_p140])./[volumeGs]');
%
pairedg_idx = find(mints_g70s);
pairedg_idx2 = find(~mints_g70s);
disp('The number of filtered out suspected Vgltu2 cluster: ')
numel(pairedg_idx)/numel(mints_g70s)
%
statsGwater_ssss = statsGwater(pairedg_idx);
statsGwater_sssn = statsGwater(pairedg_idx2);
save([base_folder 'G_paired_3.mat'],'statsGwater_sssn','statsGwater_ssss');

%So in the end, statsVwater_ss, statsRwater_ssss, and statsGwater_ssss
%should be saved in V_paired, R_paired_3 and G_paired_3, who will be paired
%Vglut2 (blue) , Bassoon (red), and Homer (green). 

