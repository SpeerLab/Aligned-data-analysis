%%
clear all;clc
%
base_path = 'Y:\Chenghang\04_4_Color\Control_Group\7.1.20.WT_P2_CB_A\';
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

outpath = [exp_folder '\Result\4_CTB\'];
elastic_align_folder = [exp_folder 'elastic_align\conv_488\'];
%
load([outpath 'V_paired_C.mat']);
statsGwater = statsVwater_sn;
%
% num_images = num_images - 2;
clear BP BG bg2
disp('allocating arrays')
BP = zeros(info.Height, info.Width, num_images,'uint8');
BP2 = zeros(info.Height, info.Width, num_images,'uint8');
for i = 1:numel(statsGwater)
    disp(int2str(i))
    BP(statsGwater(i).PixelIdxList)=statsGwater(i).PixelValues;  
end
%
exp_folder = [base_path 'analysis\'];
convpath = [path 'conv_488\'];
convfiles = [dir([convpath '*.png']) dir([convpath '*.tif'])];
mask_folder = [exp_folder 'Result\1_Soma\'];
maskfiles = [dir([mask_folder '*.tif']) dir([mask_folder '*.png'])];

clear BG
disp('allocating arrays')
BG = zeros(info.Height, info.Width, num_images,'uint8');
disp('loading data')
parfor i = 1:num_images
BG(:,:,i) = imread([path 'Result of Stack.tif'],i);
end

BP2 = BG;
%
disp('loading data')
%
%if not present, load in stats list

%make categories for new variables in parfor loop and slice BP for use in
%parfor loop
for i=numel(statsGwater):-1:1
    disp(i)

statsGwater(i).tints_p140 = [];
statsGwater(i).volume_p140 = [];
statsGwater(i).area_p140 = [];
statsGwater(i).WeightedCentroid_p140 = [];
statsGwater(i).statxtureP_140all = [];
statsGwater(i).statxtureP_140pos = [];
centG_p140(i,1:3) = 0;
tintsG_p140(i) = 0;
volumeG_p140(i) =0;

statsGwater(i).statxture_all = [];
statsGwater(i).statxture_pos = [];
statxture_all(i,1:6) = 0;
statxture_pos(i,1:6) = 0;

%try preproccessing the BP varialbe in a for loop
   minpix = min(statsGwater(i).PixelList);  maxpix = max(statsGwater(i).PixelList);
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

parfor jj=1:numel(statsGwater)
   %
   disp(jj)
   minpix = min(statsGwater(jj).PixelList);  maxpix = max(statsGwater(jj).PixelList);
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

   for j=1: numel(statsGwater(jj).PixelList(:,1))
       curr2(statsGwater(jj).PixelList(j,2)-min2+1, ...
          statsGwater(jj).PixelList(j,1)-min1+1, ...
          statsGwater(jj).PixelList(j,3)-min3+1)= 1;  
   end
   curr1a = BPp(jj).mat;
   curr1b = BP2p(jj).mat;
   Dg = bwdistsc(curr2,[voxel(1),voxel(2),voxel(3)]);
%
 
   size2= 0;
   curr3b = Dg<=(size2); curr4b = or(curr2,curr3b);
   [y,x,z] = ind2sub(size(curr4b),find(curr4b));
   PixelList_m140 = [x,y,z];
   RPixelValues_m140 = zeros(numel(PixelList_m140(:,1)),1);
   for kk=1:numel(PixelList_m140(:,1))
      RPixelValues_m140(kk) = curr1b(PixelList_m140(kk,2),...
          PixelList_m140(kk,1), PixelList_m140(kk,3));
   end

   statsGwater(jj).tints_p140 = sum([RPixelValues_m140]);
   statsGwater(jj).area_p140 = numel([RPixelValues_m140]);
   statsGwater(jj).volume_p140 = numel([RPixelValues_m140]>0);
   statsGwater(jj).WeightedCentroid_p140(1) = sum([PixelList_m140(:,1)].*...
           double([RPixelValues_m140]))/(sum([RPixelValues_m140]));
   statsGwater(jj).WeightedCentroid_p140(2) = sum([PixelList_m140(:,2)].*...
           double([RPixelValues_m140]))/(sum([RPixelValues_m140]));
   statsGwater(jj).WeightedCentroid_p140(3) =  sum([PixelList_m140(:,3)].*...
           double([RPixelValues_m140]))/(sum([RPixelValues_m140]));
%also add these statxture, 
%    statsGwater(jj).statxtureP_140all = statxture([RPixelValues_m140]);
%    posvals2 = [RPixelValues_m140]>0;
%    statsGwater(jj).statxtureP_70pos = statxture([RPixelValues_m140(posvals2)]);
   centG_p140(jj,:) = statsGwater(jj).WeightedCentroid_p140;
   tintsG_p140(jj) = statsGwater(jj).tints_p140;
   volumeG_p140(jj) =statsGwater(jj).volume_p140;
   
 
   
%    statsGwater(jj).statxture_all = statxture([statsGwater(jj).PixelValues]);
%    posvals = [statsGwater(jj).PixelValues]>0;
%    statsGwater(jj).statxture_pos = statxture([statsGwater(jj).PixelValues(posvals)]);
%    statxture_all(jj,:) = statsGwater(jj).statxture_all;
%    statxture_pos(jj,:) = statsGwater(jj).statxture_pos;
end
%%
tints = [statsGwater.tints_p140];
t = log10(1+tints);
figure;
hist(t,40)
figure;
plot(sort(t))
multithresh(t,1)
%%
thre = 0;

addback_list = find(t > thre);
addback = statsVwater_sn(addback_list);
numel(addback)
numel(addback) / numel(statsVwater_sn)
%%
statsVwater_sn(addback_list) = [];
statsVwater_ss = cat(1,statsVwater_ss,addback);
%%
save([outpath 'V_paired_C.mat'],'statsVwater_ss','statsVwater_sn');
%%
save_path = 'X:\Chenghang\OPN4_SCN\2021.4.25_P8Het_A\analysis\Result\Data\';
temp = [statsVwater_ss.Area];
temp = temp';
save([save_path 'statsVwater_sss.Area.txt'],'temp','-ascii','-double');
temp = [statsVwater_ss.TintsG];
temp = temp';
save([save_path 'statsVwater_sss.TintsG.txt'],'temp','-ascii','-double');
temp = [statsVwater_sn.Area];
temp = temp';
save([save_path 'statsVwater_ssn.Area.txt'],'temp','-ascii','-double');
temp = [statsVwater_sn.TintsG];
temp = temp';
save([save_path 'statsVwater_ssn.TintsG.txt'],'temp','-ascii','-double');