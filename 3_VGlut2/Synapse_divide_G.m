base_folder = 'Y:\Chenghang\04_4_Color\Control_Group\7.1.20.WT_P2_CB_B\analysis\Result\5_V_Syn\';
outpath = base_folder;
%
load([base_folder 'statsG2w10_edges_plus_Vglut2.mat']);
voxel = [15.5 15.5 70];
%
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

%%
save_path = 'Y:\Chenghang\04_4_Color\Control_Group\Quantified result\7.1.20.WT_P2_CB_B\';
temp = [statsGwater_ssss.Volume1_0];
temp = temp';
save([save_path 'statsGwater_ssss.Area.txt'],'temp','-ascii','-double');
temp = [statsGwater_ssss.TintsG];
temp = temp';
save([save_path 'statsGwater_ssss.TintsG.txt'],'temp','-ascii','-double');