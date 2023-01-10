clear;clc
%
base_folder = 'X:\Chenghang\4_Color\Raw\1.12.2021_P8EC_A\analysis\Result\4_CTB\';
outpath = base_folder;
%
load([base_folder 'R_add_to_statsVCw10_edges_out.mat'],'tintsG_p140');
mints_g70s = tintsG_p140;
%
pairedg_idx = find(mints_g70s);
pairedg_idx2 = find(~mints_g70s);
% pairedp_idx = -((L2(1)/L2(2))*val5w + K2/L2(2))>val6w;
% numel(find(pairedp_idx))/numel((pairedp_idx))
%
save([base_folder 'pairing_index_ps_gs_withedges_out.mat'],'pairedg_idx')
% save([base_folder 'wga_normalization_pixels_withedges.mat'],'CW2')

%
load([outpath 'statsR2w10_edges_plus_VC_out.mat']);
statsRwater_sssss = statsGwater(pairedg_idx);
statsRwater_ssssn = statsGwater(pairedg_idx2);
save([base_folder 'R_paired_VC_out.mat'],'statsRwater_sssss','statsRwater_ssssn');
%%
save_path = 'X:\Chenghang\4_Color\Raw\1.12.2021_P8EC_A\analysis\Result\Data\';
temp = [statsRwater_sssss.Area];
temp = temp';
save([save_path 'statsRwater_sssss.Area_out.txt'],'temp','-ascii','-double');
temp = [statsRwater_sssss.TintsG];
temp = temp';
save([save_path 'statsRwater_sssss.TintsG_out.txt'],'temp','-ascii','-double');
temp = [statsRwater_ssssn.Area];
temp = temp';
save([save_path 'statsRwater_ssssn.Area_out.txt'],'temp','-ascii','-double');
temp = [statsRwater_ssssn.TintsG];
temp = temp';
save([save_path 'statsRwater_ssssn.TintsG_out.txt'],'temp','-ascii','-double');
