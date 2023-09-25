%add_to_statsG
%add statxture and pixellist_140 and opposing channel volume, tints, and 
%weighted centroid to statslist
%load in statslist and opposing channel image
%cluster_seg_whole
%%
clear all;clc
%
data_path = 'X:\Chenghang\Backup_Raw_Data\Shell_Analysis\data_p140_CTBpos\';
% pathname = strings(36,1);
% pathname(1) = ['Z:\Chenghang\1.2.2021_P2EA_A\'];
% pathname(2) = ['Z:\Chenghang\1.2.2021_P2EA_B\'];
% pathname(3) = ['Z:\Chenghang\1.4.2021_P2EB_A\'];
% pathname(4) = ['Z:\Chenghang\1.4.2021_P2EB_B\'];
% pathname(5) = ['X:\Chenghang\4_Color\Raw\1.6.2021_P2EC_A\'];
% pathname(6) = ['X:\Chenghang\4_Color\Raw\1.6.2021_P2EC_B\'];
% pathname(7) = ['Z:\Chenghang\7.2.20.WT_P4EA\'];
% pathname(8) = ['Z:\Chenghang\7.29.2020_P4EB\'];
% pathname(9) = ['Z:\Chenghang\9.25.2020_P4EC_A\'];
% pathname(10) = ['Z:\Chenghang\9.25.2020_P4EC_B\'];
% pathname(11) = ['Z:\Chenghang\12.5.2020_P4ED_A\'];
% pathname(12) = ['Z:\Chenghang\12.5.2020_P4ED_B\'];
% pathname(13) = ['Z:\Chenghang\12.21.2020_P8EA_A\'];
% pathname(14) = ['Z:\Chenghang\12.21.2020_P8EA_B\'];
% pathname(15) = ['X:\Chenghang\4_Color\Raw\12.23.2020_P8EB_A\'];
% pathname(16) = ['X:\Chenghang\4_Color\Raw\12.23.2020_P8EB_B\'];
% pathname(17) = ['X:\Chenghang\4_Color\Raw\1.12.2021_P8EC_A\'];
% pathname(18) = ['X:\Chenghang\4_Color\Raw\1.12.2021_P8EC_B\'];
% pathname(19) = ['Z:\Chenghang\9.29.2020_B2P2A_A\'];
% pathname(20) = ['Z:\Chenghang\9.29.2020_B2P2A_B\'];
% pathname(21) = ['X:\Chenghang\4_Color\Raw\12.13.2020_B2P2B_A\'];
% pathname(22) = ['X:\Chenghang\4_Color\Raw\12.13.2020_B2P2B_B\'];
% pathname(23) = ['Z:\Chenghang\12.18.2020_B2P2C_A\'];
% pathname(24) = ['Z:\Chenghang\12.18.2020_B2P2C_B\'];
% pathname(25) = ['Z:\Chenghang\10.3.2020_B2P4A_A\'];
% pathname(26) = ['Z:\Chenghang\10.3.2020_B2P4A_B\'];
% pathname(27) = ['Z:\Chenghang\10.27.2020_B2P4B_A\'];
% pathname(28) = ['Z:\Chenghang\10.27.2020_B2P4B_B\'];
% pathname(29) = ['Z:\Chenghang\12.8.2020_B2P4C_A\'];
% pathname(30) = ['Z:\Chenghang\12.8.2020_B2P4C_B\'];
% pathname(31) = ['Z:\Chenghang\12.12.2020_B2P8A_A\'];
% pathname(32) = ['Z:\Chenghang\12.12.2020_B2P8A_B\'];
% pathname(33) = ['X:\Chenghang\4_Color\Raw\1.13.2021_B2P8B_A\'];
% pathname(34) = ['X:\Chenghang\4_Color\Raw\1.13.2021_B2P8B_B\'];
% pathname(35) = ['X:\Chenghang\4_Color\Raw\1.11.2021_B2P8C_A\'];
% pathname(36) = ['X:\Chenghang\4_Color\Raw\1.11.2021_B2P8C_B\'];

pathname = strings(18,1);
pathname(1) = ['X:\Chenghang\Backup_Raw_Data\1.2.2021_P2EA_B\'];
pathname(2) = ['X:\Chenghang\Backup_Raw_Data\1.4.2021_P2EB_B\'];
pathname(3) = ['X:\Chenghang\4_Color\Raw\1.6.2021_P2EC_B\'];
pathname(4) = ['X:\Chenghang\Backup_Raw_Data\7.29.2020_P4EB\'];
pathname(5) = ['X:\Chenghang\Backup_Raw_Data\9.25.2020_P4EC_B\'];
pathname(6) = ['X:\Chenghang\Backup_Raw_Data\12.5.2020_P4ED_B\'];
pathname(7) = ['X:\Chenghang\Backup_Raw_Data\12.21.2020_P8EA_B\'];
pathname(8) = ['X:\Chenghang\4_Color\Raw\12.23.2020_P8EB_B\'];
pathname(9) = ['X:\Chenghang\4_Color\Raw\1.12.2021_P8EC_B\'];
pathname(10) = ['X:\Chenghang\Backup_Raw_Data\9.29.2020_B2P2A_B\'];
pathname(11) = ['X:\Chenghang\4_Color\Raw\12.13.2020_B2P2B_B\'];
pathname(12) = ['X:\Chenghang\Backup_Raw_Data\12.18.2020_B2P2C_B\'];
pathname(13) = ['X:\Chenghang\Backup_Raw_Data\10.3.2020_B2P4A_B\'];
pathname(14) = ['X:\Chenghang\Backup_Raw_Data\10.27.2020_B2P4B_B\'];
pathname(15) = ['X:\Chenghang\Backup_Raw_Data\12.8.2020_B2P4C_B\'];
pathname(16) = ['X:\Chenghang\Backup_Raw_Data\12.12.2020_B2P8A_B\'];
pathname(17) = ['X:\Chenghang\4_Color\Raw\1.13.2021_B2P8B_B\'];
pathname(18) = ['X:\Chenghang\4_Color\Raw\1.11.2021_B2P8C_B\'];
%
for cur_path = 1:1:18
%
base_path = char(pathname(cur_path));

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
V_Syn_outpath = [exp_folder '\Result\4_CTB\'];
% mkdir([exp_folder '\Result\6_B_VGlut2']);
outpath = [exp_folder '\Result\6_B_VGlut2\'];
%
load([V_outpath 'V_paired.mat']);
statsRwater = statsVwater_ss;
clear statsGwater
%
% load([outpath_syn 'G_paired_2.mat']);
% statsGwater = statsGwater_sss;
%
statsSwater = statsRwater;
%
load([V_Syn_outpath 'R_paired_VC']);
statsVwater = statsRwater_sssss;

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
disp('loading data')
%
%if not present, load in stats list

%make categories for new variables in parfor loop and slice BP for use in
%parfor loop
for i=numel(statsVwater):-1:1
    disp(i)

statsVwater(i).tints_p140 = [];
statsVwater(i).volume_p140 = [];
statsVwater(i).area_p140 = [];
statsVwater(i).WeightedCentroid_p140 = [];
statsVwater(i).statxtureP_140all = [];
statsVwater(i).statxtureP_140pos = [];
centG_p140(i,1:3) = 0;
tintsG_p140(i) = 0;
volumeG_p140(i) =0;

statsVwater(i).statxture_all = [];
statsVwater(i).statxture_pos = [];
statxture_all(i,1:6) = 0;
statxture_pos(i,1:6) = 0;

%try preproccessing the BP varialbe in a for loop
   minpix = min(statsVwater(i).PixelList);  maxpix = max(statsVwater(i).PixelList);
   min1 = minpix(1)-30; min2 = minpix(2)-30; min3 = minpix(3)-6;
   max1 = maxpix(1)+30; max2 = maxpix(2)+30; max3 = maxpix(3)+6;
   if min1 < 1; min1=1; end 
   if min2 < 1; min2=1; end
   if min3 < 1; min3=1; end
   if max1 > info.Width; max1=info.Width; end
   if max2 > info.Height; max2=info.Height; end
   if max3 > num_images; max3=num_images; end      
   BPp(i).mat = BP(min2:max2,min1:max1,min3:max3); 
   BP2p(i).mat = BP2(min2:max2,min1:max1,min3:max3); 
end
%

parfor jj=1:numel(statsVwater)
   %
   disp(jj)
   minpix = min(statsVwater(jj).PixelList);  maxpix = max(statsVwater(jj).PixelList);
   min1 = minpix(1)-30; min2 = minpix(2)-30; min3 = minpix(3)-6;
   max1 = maxpix(1)+30; max2 = maxpix(2)+30; max3 = maxpix(3)+6;
   if min1 < 1; min1=1; end 
   if min2 < 1; min2=1; end
   if min3 < 1; min3=1; end
   if max1 > info.Width; max1=info.Width; end
   if max2 > info.Height; max2=info.Height; end
   if max3 > num_images; max3=num_images; end        

   size1 = max1-min1 + 1; size2 = max2-min2 + 1; size3 = max3-min3 + 1;
   curr2 = false(size2, size1, size3);

   for j=1: numel(statsVwater(jj).PixelList(:,1))
       curr2(statsVwater(jj).PixelList(j,2)-min2+1, ...
          statsVwater(jj).PixelList(j,1)-min1+1, ...
          statsVwater(jj).PixelList(j,3)-min3+1)= 1;  
   end
   curr1a = BPp(jj).mat;
   curr1b = BP2p(jj).mat;
   Dg = bwdistsc(curr2,[voxel(1),voxel(2),voxel(3)]);
%

   size2= 140;
   curr3b = Dg<=(size2); curr4b = or(curr2,curr3b);
   [y,x,z] = ind2sub(size(curr4b),find(curr4b));
   PixelList_m140 = [x,y,z];
   RPixelValues_m140 = zeros(numel(PixelList_m140(:,1)),1);
   for kk=1:numel(PixelList_m140(:,1))
      RPixelValues_m140(kk) = curr1b(PixelList_m140(kk,2),...
          PixelList_m140(kk,1), PixelList_m140(kk,3));
   end

   statsVwater(jj).tints_p140 = sum([RPixelValues_m140]);
   statsVwater(jj).area_p140 = numel([RPixelValues_m140]);
   statsVwater(jj).volume_p140 = numel(find(RPixelValues_m140));
   statsVwater(jj).WeightedCentroid_p140(1) = sum([PixelList_m140(:,1)].*...
           double([RPixelValues_m140]))/(sum([RPixelValues_m140]));
   statsVwater(jj).WeightedCentroid_p140(2) = sum([PixelList_m140(:,2)].*...
           double([RPixelValues_m140]))/(sum([RPixelValues_m140]));
   statsVwater(jj).WeightedCentroid_p140(3) =  sum([PixelList_m140(:,3)].*...
           double([RPixelValues_m140]))/(sum([RPixelValues_m140]));
%also add these statxture, 
%    statsVwater(jj).statxtureP_140all = statxture([RPixelValues_m140]);
%    posvals2 = [RPixelValues_m140]>0;
%    statsVwater(jj).statxtureP_70pos = statxture([RPixelValues_m140(posvals2)]);
   centG_p140(jj,:) = statsVwater(jj).WeightedCentroid_p140;
   tintsG_p140(jj) = statsVwater(jj).tints_p140;
   volumeG_p140(jj) =statsVwater(jj).volume_p140;
   
  

   
%    statsVwater(jj).statxture_all = statxture([statsVwater(jj).PixelValues]);
%    posvals = [statsVwater(jj).PixelValues]>0;
%    statsVwater(jj).statxture_pos = statxture([statsVwater(jj).PixelValues(posvals)]);
%    statxture_all(jj,:) = statsVwater(jj).statxture_all;
%    statxture_pos(jj,:) = statsVwater(jj).statxture_pos;
end

area_p140 = [statsVwater.volume_p140]';
tints_p140 = [statsVwater.tints_p140]';
save([outpath 'shell_p140_CTBpos.mat'],'area_p140','tints_p140');

temp = area_p140;

save([data_path 'Area_' sprintf('%03d',cur_path) '.txt'],'temp','-ascii','-double');
temp = tints_p140;

save([data_path 'Tints_' sprintf('%03d',cur_path) '.txt'],'temp','-ascii','-double');

end

