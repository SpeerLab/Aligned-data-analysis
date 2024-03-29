clear;clc
%
base_folder = 'Y:\Chenghang\04_4_Color\Control_Group\7.1.20.WT_P2_CB_B\analysis\Result\4_CTB\';
outpath = base_folder;
%
load([base_folder 'G_add_to_statsVCw10_edges.mat'],'tintsG_p140');
mints_g70s = tintsG_p140;
%
pairedg_idx = find(mints_g70s);
pairedg_idx2 = find(~mints_g70s);
% pairedp_idx = -((L2(1)/L2(2))*val5w + K2/L2(2))>val6w;
% numel(find(pairedp_idx))/numel((pairedp_idx))
%
save([base_folder 'pairing_index_ps_gs_withedges.mat'],'pairedg_idx')
% save([base_folder 'wga_normalization_pixels_withedges.mat'],'CW2')

%
load([outpath 'statsG2w10_edges_plus_VC.mat']);
statsGwater_sssss = statsGwater(pairedg_idx);
statsGwater_ssssn = statsGwater(pairedg_idx2);
save([base_folder 'G_paired_VC.mat'],'statsGwater_sssss','statsGwater_ssssn');
%%
save_path = 'Y:\Chenghang\04_4_Color\Control_Group\Quantified result\7.1.20.WT_P2_CB_B\';
temp = [statsGwater_sssss.Volume1_0];
temp = temp';
save([save_path 'statsGwater_sssss.Area.txt'],'temp','-ascii','-double');
temp = [statsGwater_sssss.TintsG];
temp = temp';
save([save_path 'statsGwater_sssss.TintsG.txt'],'temp','-ascii','-double');
temp = [statsGwater_ssssn.Volume1_0];
temp = temp';
save([save_path 'statsGwater_ssssn.Area.txt'],'temp','-ascii','-double');
temp = [statsGwater_ssssn.TintsG];
temp = temp';
save([save_path 'statsGwater_ssssn.TintsG.txt'],'temp','-ascii','-double');