base_folder = 'X:\Chenghang\OPN4_SCN\OPN4_SCN_KO_P8_R_B\analysis\Result\5_V_Syn\';
outpath = base_folder;
%
load([base_folder 'statsR2w10_edges_plus_Vglut2.mat']);
voxel = [15.5 15.5 70];
%
for i =1:numel(statsRwater)
    volumeRs(i,1) = statsRwater(i).Area;
end

%
load([base_folder 'add_to_statsRw10_edges_Vglut2.mat'],'tintsG_p140');
mints_g70s = (([tintsG_p140])./[volumeRs]');
%
pairedg_idx = find(mints_g70s);
pairedg_idx2 = find(~mints_g70s);
disp('The number of filtered out suspected Vgltu2 cluster: ')
numel(pairedg_idx)/numel(mints_g70s)
%
statsRwater_ssss = statsRwater(pairedg_idx);
statsRwater_sssn = statsRwater(pairedg_idx2);
save([base_folder 'R_paired_3.mat'],'statsRwater_sssn','statsRwater_ssss');
%%
save_path = 'C:\Users\Chenghang\Desktop\Data\OPN4\KO_R_B\';
temp = [statsRwater_ssss.Volume1_0];
temp = temp';
save([save_path 'statsRwater_ssss.Area.txt'],'temp','-ascii','-double');
temp = [statsRwater_ssss.TintsG];
temp = temp';
save([save_path 'statsRwater_ssss.TintsG.txt'],'temp','-ascii','-double');
