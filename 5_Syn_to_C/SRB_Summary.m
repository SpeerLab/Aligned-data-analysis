clear;clc;
base_path = 'Z:\Chenghang\OPN4SCN\6202_P8_Het_A\';
Result_folder = [base_path 'analysis\Result\'];
Syn_path = Result_folder;
V_path = [Result_folder '3_Vglut2\'];
CTB_path = [Result_folder '4_CTB\'];
V_Syn_path = [Result_folder '5_V_Syn\'];
C_Syn_path = [Result_folder '6_Syn_CTB\'];

load([Syn_path 'G_paired_2.mat']);
load([Syn_path 'R_paired_2.mat']);
load([V_path 'V_paired.mat']);

%Mark synapses paired with VGluT2. 
load([V_Syn_path 'G_paired_V_id.mat'])
GV_pair_id = pairedg_idx;
load([V_Syn_path 'R_paired_GV_id.mat'])
RV_pair_id = pairedg_idx;
for i = 1:numel(statsGwater_sss)
	statsGwater_sss(i).Pair_V = GV_pair_id(i);
end
for i = 1:numel(statsRwater_sss)
	statsRwater_sss(i).Pair_V = RV_pair_id(i);
end

%Mark VGLuT2 paired with CTB. 
load([CTB_path 'V_paired_C_id.mat'])
VC_pair_id = pairedg_idx;
for i = 1:numel(statsVwater_ss)
	statsVwater_ss(i).Pair_C = VC_pair_id(i);
end

%Mark synapses paired with VC. 
load([CTB_path 'G_paired_VC_id.mat'])
GVC_pair_id = pairedg_idx;
load([CTB_path 'R_paired_GVC_id.mat'])
RVC_pair_id = pairedg_idx;
count = 1;
for i = 1:numel(statsGwater_sss)
	if statsGwater_sss(i).Pair_V == 1
		statsGwater_sss(i).Pair_VC = GVC_pair_id(count);
		count = count+1;
	end
end
count = 1;
for i = 1:numel(statsRwater_sss)
	if statsRwater_sss(i).Pair_V == 1
		statsRwater_sss(i).Pair_VC = RVC_pair_id(count);
		count = count+1;
	end
end

%Mark synapses paired with CTB. 
load([C_Syn_path 'G_paired_C_id.mat'])
GC_pair_id = pairedg_idx;
load([C_Syn_path 'R_paired_GC_id.mat'])
RGC_pair_id = pairedg_idx;
for i = 1:numel(statsGwater_sss)
	statsGwater_sss(i).Pair_C = GC_pair_id(i);
end
for i = 1:numel(statsRwater_sss)
	statsRwater_sss(i).Pair_C = RGC_pair_id(i);
end

%Summary: 
%statsGwater_sss.Pair_V
%statsRwater_sss.Pair_V
%StatsVwater_ss.Pair_C
%statsGwater_sss.Pair_VC
%statsRwater_sss.Pair_VC
%statsGwater_sss.Pair_C
%statsRwater_sss.Pair_C
%%
