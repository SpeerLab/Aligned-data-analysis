%add_to_statsG
%add statxture and pixellist_140 and opposing channel volume, tints, and 
%weighted centroid to statslist
%load in statslist and opposing channel image
%cluster_seg_whole
%%
clear all;clc
%
pathname = ['X:\Chenghang\Backup_Raw_Data\1.2.2021_P2EA_B\'];
%

base_path = pathname;

exp_folder = [base_path 'analysis\'];
path = [exp_folder  'elastic_align\'];
mergedpath = [path 'storm_merged/'];
%
mergedfiles = [dir([mergedpath '*.png']) dir([mergedpath '*.tif'])];
num_images = numel(mergedfiles);
info = imfinfo([mergedpath mergedfiles(1,1).name]);
disp(num_images)
%set voxel size in nm
voxel=[15.5, 15.5, 70];

V_outpath = [exp_folder '\Result\3_Vglut2\'];
V_Syn_outpath = [exp_folder '\Result\5_V_Syn\'];
mkdir([exp_folder '\Result\6_B_VGlut2']);
outpath = [exp_folder '\Result\6_B_VGlut2\'];
%
load([V_outpath 'v_paired.mat']);
statsRwater = statsVwater_ss;
clear statsGwater
%
% load([outpath_syn 'G_paired_2.mat']);
% statsGwater = statsGwater_sss;
%
statsSwater = statsRwater;
%
load([V_Syn_outpath 'R_paired_3']);
statsVwater = statsRwater_ssss;

%
clear BP BG bg2
disp('allocating arrays')
BP = zeros(info.Height, info.Width, num_images,'uint8');
BP2 = zeros(info.Height, info.Width, num_images,'uint8');
for i = 1:numel(statsVwater)
    disp(int2str(i))
    BP(statsVwater(i).PixelIdxList)=statsVwater(i).PixelValues;  
end
%
%BP2 = BP;
for i = 1:numel(statsSwater)
    disp(int2str(i))
    BP2(statsSwater(i).PixelIdxList)=statsSwater(i).PixelValues;  
end
%
BP_5 = BP(:,:,1:10);
BP2_5 = BP2(:,:,1:10);
logic_BP = logical(BP_5);
Dis = bwdistsc(logic_BP,[voxel(1),voxel(2),voxel(3)]);
size2= 70;
Logic_Dis = Dis<=(size2); 
%
Shell_V = zeros(size(BP_5,1),size(BP_5,2),size(BP_5,3),'uint8');
Shell_V(Logic_Dis) = BP2_5(Logic_Dis);
outpath = 'X:\Chenghang\Backup_Raw_Data\12.12.2020_B2P8A_B\analysis\Nano_Cluster\';
imwrite(Shell_V(:,:,2),[outpath 'shell_073.tif']);
imwrite(Shell_V(:,:,5),[outpath 'shell_076.tif']);
imwrite(Shell_V(:,:,9),[outpath 'shell_080.tif']);