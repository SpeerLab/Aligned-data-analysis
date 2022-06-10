clear;clc;
%
exp_folder = 'X:\Chenghang\OPN4_SCN\OPN4_SCN_Het_P60_A\analysis\';
%Box_thick is used to calculate the boundary of the image block. 
%Dis_thick is used to expand the identified soma area. 
%Channel: R=1,G=2,B=3.
%gauss_id: the gaussian blur parameter. Higher if the soma staining is not
%prominent. 
Box_thick = 6;
Dis_thick = 40;
channel = 2;
gauss_id = 3;

%
path = [exp_folder  'elastic_align/'];

stormpath = [path 'storm_merged/'];
stormfiles = [dir([stormpath '*.tif']) dir([stormpath '*.png'])];
num_images = numel(stormfiles);
infos = imfinfo([stormpath stormfiles(1,1).name]);

convpath = [path 'conv_merged\'];
convfiles = [dir([convpath '*.tif']) dir([convpath '*.png'])];

mkdir([exp_folder 'Result']);
mkdir([exp_folder 'Result\1_soma']);
mkdir([exp_folder 'Result\0_BD'])
outpath = [exp_folder 'Result\1_Soma\'];
voxels=[(15.5), (15.5), 70];

BYs = zeros(ceil((infos(1,1).Height)),ceil((infos(1,1).Width)),num_images,'uint8');
BD = zeros(ceil((infos(1,1).Height)),ceil((infos(1,1).Width)),num_images,'uint8');
Area = zeros(num_images,1);
Area2 = zeros(num_images,1);
%
%Calculate the boundary of the image. 
parfor k = 1:num_images
    disp(k)
    A = imread([convpath convfiles(k,1).name]);
    C = A(:,:,channel) * 255;
    gausspix = 3;
    B = imfilter(C,fspecial('gaussian',gausspix,gausspix),'same','replicate');
    B = B * 255 - C;
    gausspix = 2*Box_thick + 1;
    D = imfilter(B,fspecial('gaussian',gausspix,gausspix),'same','replicate');
    D = D * 255;
    for i = 1:size(C,1)
        if C(i,1) > 0
            D(i,1:Box_thick)= 255;
        end
        if C(i,size(C,2)) > 0
            D(i,size(C,2)-Box_thick:size(C,2)) = 255;
        end
    end
    for i = 1:size(C,2)
        if C(1,i) > 0
            D(1:Box_thick,i) = 255;
        end
        if C(size(C,1),i) > 0
            D(size(C,1)-Box_thick:size(C,1),i) = 255;
        end
    end
    BD(:,:,k) = D;
end
%
outlier = zeros(ceil((infos(1,1).Height)),ceil((infos(1,1).Width)),num_images,'uint8');
A2 = zeros(ceil((infos(1,1).Height)),ceil((infos(1,1).Width)),num_images,'uint8');
for i = 1:size(BD,3)
    CD = imfill(BD(:,:,i));
    A2(:,:,i) = CD;
    DD = imcomplement(CD);
    outlier(:,:,i) = DD;
end
%
parfor k = 1:num_images
    A = imread([stormpath stormfiles(k,1).name]);
    BYs(:,:,k) = A(:,:,channel);
end

% bad_sec = [2];
% BYs(:,:,bad_sec) = [];
num_images_2 = size(BYs,3);
%
gausspix = (gauss_id);

bg2 = zeros(size(BYs),'uint8');
parfor k=1:num_images_2
    disp(k)
    bg2(:,:,k) = (imfilter(BYs(:,:,k),fspecial('gaussian',gausspix,gausspix),'same','replicate'));
end

%%
clear hy1
parfor j=1:num_images_2
    disp(j)
     A1 = bg2(:,:,j); 
     A1a = A1(logical(A1));
     hist_result =histogram(A1a,0:1:255)
     hy = hist_result.Values;
     hx = hist_result.Data;
     hy1(j,:) = hy;
end
%
hx2 = 0:255;
hy1dist = [];
mhy1 = mean(hy1)./10;
for i=1:numel(mhy1)
nums = ones(1,round(mhy1(i))).*hx2(i);       
hy1dist = cat(2,hy1dist,nums);
end
%
% figure;
% hist(hy1dist,255)

threshfactorg = double(multithresh(hy1dist,3));
t_use = threshfactorg(1)/256 %#ok<NOPTS> 
%%
%0.07
t_use = 1;
%
disp('making CG')
CG = false(size(bg2));
parfor k=1:size(bg2,3)
    CG(:,:,k) = im2bw(bg2(:,:,k), t_use);
end
% imwrite(double(CG(:,:,1)),[outpath 'mask' '.tif']);
%
%
disp('making CCG')
CCG = bwconncomp(CG,26); 
%clear CG
disp('making statsG')

statsG = regionprops(CCG,BYs,'Area','PixelIdxList','PixelValues','PixelList','WeightedCentroid');
statsGgauss = regionprops(CCG,bg2,'Area','PixelIdxList','PixelValues','PixelList','WeightedCentroid');

%
new_G = zeros(ceil((infos(1,1).Height)),ceil((infos(1,1).Width)),num_images,'uint8');
%
% the size threshold here might need modification. 
statsG_temp = statsGgauss(find(log(1+[statsGgauss.Area])> 11.5));
numel(statsG_temp)
%
for i = 1:size(statsG_temp,1)
% for i = 1:10
    disp(i)
    PixelList = statsG_temp(i).PixelList;
    PixelValues = statsG_temp(i).PixelValues;
    for j = 1:size(PixelList,1)
        y = PixelList(j,1);
        x = PixelList(j,2);
        z = PixelList(j,3);
        new_G(x,y,z) = 1;
    end
end
%
%  imagesc(new_G(:,:,1))

imwrite(new_G(:,:,1) * 255,[outpath 'Soma_test_1.tif']);

%%
new_G = logical(new_G);

F = zeros(ceil((infos(1,1).Height)),ceil((infos(1,1).Width)),num_images,'uint8');
F = logical(F);

size2 = Dis_thick;
parfor i = 1:num_images
    Dg = bwdistsc(new_G(:,:,i));
    curr = Dg<=(size2);
    Temp_BD = logical(BD(:,:,i));
    %Note: 200 is an artifical number here. Soma on the edge at x=200 won't
    %be filled. 
    Temp_BD(1:infos.Height,200) = 0;
    Temp_BD(2500,1:infos.Width) = 0;
    Temp_BD(600,1:infos.Width) = 0;
    Temp_BD(1:infos.Height,3000) = 0;
    curr = curr + Temp_BD;
    curr = imfill(curr,4,'holes');
    F(:,:,i) = logical(uint8(curr) + uint8(BD(:,:,i))) + logical(outlier(:,:,i));
    %Calculate the area after the filter: 
    A = F(:,:,i);
    Area(i) = numel(find(~A));
end

for i = 1:size(A2,3)
    Area2(i) = numel(find(A2(:,:,i)));
end

%
for i = 1:num_images_2
    imwrite(double(F(:,:,i)),[outpath 'F_' sprintf('%03d',i) '.tif']);
    imwrite(double(A2(:,:,i)),[exp_folder 'Result/0_BD/' 'A2_' sprintf('%03d',i) '.tif']);
end
%%
%Area: Width*length - all outlier including soma, boundary, and corner (outside boundary). 
%Area2: everything inside the boundary. 
save_path = 'C:\Users\Chenghang\Desktop\Data\OPN4\60_het_A\';
temp = Area;
save([save_path 'Area.txt'],'temp','-ascii','-double');
temp = Area2;
save([save_path 'Area2.txt'],'temp','-ascii','-double');