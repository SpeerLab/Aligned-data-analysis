load('X:\Chenghang\Backup_Raw_Data\12.21.2020_P8EA_B\analysis\Result\4_CTB\V_paired_C.mat');
%%
statsVwater_ss_S = statsVwater_ss(log10([statsVwater_ss.Area]*0.0155*0.0155*0.07) < -2.1807);