clear;clc
%
base_folder = 'Z:\Chenghang\OPN4SCN\8262_KO_P60_C\analysis\Result\6_Syn_CTB\';
outpath = base_folder;
%
load([base_folder 'R_add_to_statsGCw10_edges.mat'],'tintsG_p140');
mints_g70s = tintsG_p140;
%
pairedg_idx = find(mints_g70s);

R_paired_GC_id = zeros(numel(mints_g70s),1);
R_paired_GC_id(pairedg_idx) = 1;
R_paired_GC_id = logical(R_paired_GC_id);
pairedg_idx = R_paired_GC_id;
save([outpath 'R_paired_GC_id.mat'],'pairedg_idx');

% save([base_folder 'wga_normalization_pixels_withedges.mat'],'CW2')

%
load([outpath 'statsR2w10_edges_plus_GC.mat']);
statsRwater_Cs = statsGwater(pairedg_idx);
statsRwater_Cn = statsGwater(~pairedg_idx);
save([base_folder 'R_paired_GC.mat'],'statsRwater_Cs','statsRwater_Cn');
%%
save_path = 'Z:\Chenghang\OPN4SCN\Quantification_V4\8262_KO_P60_C\';
temp = [statsRwater_Cs.Volume1_0];
temp = temp';
save([save_path 'statsRwater_Cs.Area.txt'],'temp','-ascii','-double');
temp = [statsRwater_Cs.TintsG];
temp = temp';
save([save_path 'statsRwater_Cs.TintsG.txt'],'temp','-ascii','-double');
temp = [statsRwater_Cn.Volume1_0];
temp = temp';
save([save_path 'statsRwater_Cn.Area.txt'],'temp','-ascii','-double');
temp = [statsRwater_Cn.TintsG];
temp = temp';
save([save_path 'statsRwater_Cn.TintsG.txt'],'temp','-ascii','-double');