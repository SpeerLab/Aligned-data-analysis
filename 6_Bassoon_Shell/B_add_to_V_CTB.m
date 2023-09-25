%
%%
clear all;clc
%
data_path = 'C:\Users\Chenghang\Desktop\Data\';

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
%%
for cur_path = 1:1:18
    %
    base_path = char(pathname(cur_path));
    disp(base_path);
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
    
    V_Syn_outpath = [exp_folder '\Result\4_CTB\'];
    outpath = [exp_folder '\Result\6_B_VGlut2\'];
    if exist(outpath) ~= 7
        mkdir(outpath);
    end
    %
    %The original code would be searching R within a V shell. 
    load([V_Syn_outpath 'V_paired_C.mat']);
    clear statsSwater
    statsSwater = statsVwater_sn;
    load([V_Syn_outpath 'R_paired_VC']);
    clear statsVwater
    statsVwater = statsRwater_ssssn;
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
    for i = 1:numel(statsSwater)
        disp(int2str(i))
        BP2(statsSwater(i).PixelIdxList)=statsSwater(i).PixelValues;
    end
    %
    disp('loading data')
    for i=numel(statsVwater):-1:1
        disp(i)
        %Area means all pixels while volume contains only positive pixels. 
        statsVwater(i).tints_p16 = [];
        statsVwater(i).volume_p16 = [];
        statsVwater(i).area_p16 = [];
        statsVwater(i).WeightedCentroid_p16 = [];
        statsVwater(i).tints_p32 = [];
        statsVwater(i).volume_p32 = [];
        statsVwater(i).area_p32 = [];
        statsVwater(i).WeightedCentroid_p32 = [];
        statsVwater(i).tints_p48 = [];
        statsVwater(i).volume_p48 = [];
        statsVwater(i).area_p48 = [];
        statsVwater(i).WeightedCentroid_p48 = [];
        statsVwater(i).tints_p64 = [];
        statsVwater(i).volume_p64 = [];
        statsVwater(i).area_p64 = [];
        statsVwater(i).WeightedCentroid_p64 = [];
        statsVwater(i).tints_p80 = [];
        statsVwater(i).volume_p80 = [];
        statsVwater(i).area_p80 = [];
        statsVwater(i).WeightedCentroid_p80 = [];
        
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
        
        size2= 16;
        curr3b = Dg<=(size2); curr4b = or(curr2,curr3b);
        [y,x,z] = ind2sub(size(curr4b),find(curr4b));
        PixelList_m16 = [x,y,z];
        RPixelValues_m16 = zeros(numel(PixelList_m16(:,1)),1);
        for kk=1:numel(PixelList_m16(:,1))
            RPixelValues_m16(kk) = curr1b(PixelList_m16(kk,2),...
                PixelList_m16(kk,1), PixelList_m16(kk,3));
        end
        statsVwater(jj).tints_p16 = sum([RPixelValues_m16]);
        statsVwater(jj).area_p16 = numel([RPixelValues_m16]);
        statsVwater(jj).volume_p16 = numel(find(RPixelValues_m16));
        statsVwater(jj).WeightedCentroid_p16(1) = sum([PixelList_m16(:,1)].*...
            double([RPixelValues_m16]))/(sum([RPixelValues_m16]));
        statsVwater(jj).WeightedCentroid_p16(2) = sum([PixelList_m16(:,2)].*...
            double([RPixelValues_m16]))/(sum([RPixelValues_m16]));
        statsVwater(jj).WeightedCentroid_p16(3) =  sum([PixelList_m16(:,3)].*...
            double([RPixelValues_m16]))/(sum([RPixelValues_m16]));
        
        size2= 32;
        curr3b = Dg<=(size2); curr4b = or(curr2,curr3b);
        [y,x,z] = ind2sub(size(curr4b),find(curr4b));
        PixelList_m32 = [x,y,z];
        RPixelValues_m32 = zeros(numel(PixelList_m32(:,1)),1);
        for kk=1:numel(PixelList_m32(:,1))
            RPixelValues_m32(kk) = curr1b(PixelList_m32(kk,2),...
                PixelList_m32(kk,1), PixelList_m32(kk,3));
        end
        statsVwater(jj).tints_p32 = sum([RPixelValues_m32]);
        statsVwater(jj).area_p32 = numel([RPixelValues_m32]);
        statsVwater(jj).volume_p32 = numel(find(RPixelValues_m32));
        statsVwater(jj).WeightedCentroid_p32(1) = sum([PixelList_m32(:,1)].*...
            double([RPixelValues_m32]))/(sum([RPixelValues_m32]));
        statsVwater(jj).WeightedCentroid_p32(2) = sum([PixelList_m32(:,2)].*...
            double([RPixelValues_m32]))/(sum([RPixelValues_m32]));
        statsVwater(jj).WeightedCentroid_p32(3) =  sum([PixelList_m32(:,3)].*...
            double([RPixelValues_m32]))/(sum([RPixelValues_m32]));
        
        size2= 48;
        curr3b = Dg<=(size2); curr4b = or(curr2,curr3b);
        [y,x,z] = ind2sub(size(curr4b),find(curr4b));
        PixelList_m48 = [x,y,z];
        RPixelValues_m48 = zeros(numel(PixelList_m48(:,1)),1);
        for kk=1:numel(PixelList_m48(:,1))
            RPixelValues_m48(kk) = curr1b(PixelList_m48(kk,2),...
                PixelList_m48(kk,1), PixelList_m48(kk,3));
        end
        statsVwater(jj).tints_p48 = sum([RPixelValues_m48]);
        statsVwater(jj).area_p48 = numel([RPixelValues_m48]);
        statsVwater(jj).volume_p48 = numel(find(RPixelValues_m48));
        statsVwater(jj).WeightedCentroid_p48(1) = sum([PixelList_m48(:,1)].*...
            double([RPixelValues_m48]))/(sum([RPixelValues_m48]));
        statsVwater(jj).WeightedCentroid_p48(2) = sum([PixelList_m48(:,2)].*...
            double([RPixelValues_m48]))/(sum([RPixelValues_m48]));
        statsVwater(jj).WeightedCentroid_p48(3) =  sum([PixelList_m48(:,3)].*...
            double([RPixelValues_m48]))/(sum([RPixelValues_m48]));
        
        size2= 64;
        curr3b = Dg<=(size2); curr4b = or(curr2,curr3b);
        [y,x,z] = ind2sub(size(curr4b),find(curr4b));
        PixelList_m64 = [x,y,z];
        RPixelValues_m64 = zeros(numel(PixelList_m64(:,1)),1);
        for kk=1:numel(PixelList_m64(:,1))
            RPixelValues_m64(kk) = curr1b(PixelList_m64(kk,2),...
                PixelList_m64(kk,1), PixelList_m64(kk,3));
        end
        statsVwater(jj).tints_p64 = sum([RPixelValues_m64]);
        statsVwater(jj).area_p64 = numel([RPixelValues_m64]);
        statsVwater(jj).volume_p64 = numel(find(RPixelValues_m64));
        statsVwater(jj).WeightedCentroid_p64(1) = sum([PixelList_m64(:,1)].*...
            double([RPixelValues_m64]))/(sum([RPixelValues_m64]));
        statsVwater(jj).WeightedCentroid_p64(2) = sum([PixelList_m64(:,2)].*...
            double([RPixelValues_m64]))/(sum([RPixelValues_m64]));
        statsVwater(jj).WeightedCentroid_p64(3) =  sum([PixelList_m64(:,3)].*...
            double([RPixelValues_m64]))/(sum([RPixelValues_m64]));
        
        size2= 80;
        curr3b = Dg<=(size2); curr4b = or(curr2,curr3b);
        [y,x,z] = ind2sub(size(curr4b),find(curr4b));
        PixelList_m80 = [x,y,z];
        RPixelValues_m80 = zeros(numel(PixelList_m80(:,1)),1);
        for kk=1:numel(PixelList_m80(:,1))
            RPixelValues_m80(kk) = curr1b(PixelList_m80(kk,2),...
                PixelList_m80(kk,1), PixelList_m80(kk,3));
        end
        statsVwater(jj).tints_p80 = sum([RPixelValues_m80]);
        statsVwater(jj).area_p80 = numel([RPixelValues_m80]);
        statsVwater(jj).volume_p80 = numel(find(RPixelValues_m80));
        statsVwater(jj).WeightedCentroid_p80(1) = sum([PixelList_m80(:,1)].*...
            double([RPixelValues_m80]))/(sum([RPixelValues_m80]));
        statsVwater(jj).WeightedCentroid_p80(2) = sum([PixelList_m80(:,2)].*...
            double([RPixelValues_m80]))/(sum([RPixelValues_m80]));
        statsVwater(jj).WeightedCentroid_p80(3) =  sum([PixelList_m80(:,3)].*...
            double([RPixelValues_m80]))/(sum([RPixelValues_m80]));
    end
    

    area = [statsVwater.area_p16]';
    csvwrite([data_path 'Area_p16/' sprintf('%03d',cur_path) '.csv'],area);
    area = [statsVwater.area_p32]';
    csvwrite([data_path 'Area_p32/' sprintf('%03d',cur_path) '.csv'],area);
    area = [statsVwater.area_p48]';
    csvwrite([data_path 'Area_p48/' sprintf('%03d',cur_path) '.csv'],area);
    area = [statsVwater.area_p64]';
    csvwrite([data_path 'Area_p64/' sprintf('%03d',cur_path) '.csv'],area);
    area = [statsVwater.area_p80]';
    csvwrite([data_path 'Area_p80/' sprintf('%03d',cur_path) '.csv'],area);
    
    tints = [statsVwater.tints_p16]';
    csvwrite([data_path 'Tints_p16/' sprintf('%03d',cur_path) '.csv'],tints);
    tints = [statsVwater.tints_p32]';
    csvwrite([data_path 'Tints_p32/' sprintf('%03d',cur_path) '.csv'],tints);
    tints = [statsVwater.tints_p48]';
    csvwrite([data_path 'Tints_p48/' sprintf('%03d',cur_path) '.csv'],tints);
    tints = [statsVwater.tints_p64]';
    csvwrite([data_path 'Tints_p64/' sprintf('%03d',cur_path) '.csv'],tints);
    tints = [statsVwater.tints_p80]';
    csvwrite([data_path 'Tints_p80/' sprintf('%03d',cur_path) '.csv'],tints);
    
    volume = [statsVwater.volume_p16]';
    csvwrite([data_path 'Volume_p16/' sprintf('%03d',cur_path) '.csv'],volume);
    volume = [statsVwater.volume_p32]';
    csvwrite([data_path 'Volume_p32/' sprintf('%03d',cur_path) '.csv'],volume);
    volume = [statsVwater.volume_p48]';
    csvwrite([data_path 'Volume_p48/' sprintf('%03d',cur_path) '.csv'],volume);
    volume = [statsVwater.volume_p64]';
    csvwrite([data_path 'Volume_p64/' sprintf('%03d',cur_path) '.csv'],volume);
    volume = [statsVwater.volume_p80]';
    csvwrite([data_path 'Volume_p80/' sprintf('%03d',cur_path) '.csv'],volume);
end