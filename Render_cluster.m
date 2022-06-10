%%
%Read the filtered conventional images. 
%X:\Jackie\WACsoma_concatenated\analysis\elastic_align\synapse_analysis\test
expfolder = 'X:\Chenghang\4_Color\Raw\12.23.2020_P8EB_B\analysis\elastic_align\storm_merged\';
outpath = 'X:\Chenghang\4_Color\non_retinogeniculate_synapses\';
files = [dir([expfolder '*.tif']) dir([expfolder '*.png'])];
infos = imfinfo([expfolder files(1,1).name]);
num_images = numel(files);
%num_images = ceil(num_images / 15.5 * 70);
furtherds = 1;

new_G = zeros(ceil((infos(1,1).Height*furtherds)),ceil((infos(1,1).Width*furtherds)),num_images,'uint8');

%put the name here
statsG_temp = statsRwater_sssn;

% a = [9,3108];
% for i = 1:2
%     i = a(i);
for i = 1:numel(statsG_temp)
% for i = 1:1000
    disp(i)
    PixelList = statsG_temp(i).PixelList;
    PixelValues = statsG_temp(i).PixelValues;
    for j = 1:size(PixelList,1)
        x = PixelList(j,2);
        y = PixelList(j,1);
        z = PixelList(j,3);
        new_G(x,y,z) = PixelValues(j);
    end
end
%     i = 1000;
%     PixelList = statsRwater(i).PixelList;
%     PixelValues = statsRwater(i).PixelValues;
%     for j = 1:size(PixelList,1)
%         y = PixelList(j,1);
%         x = PixelList(j,2);
%         z = PixelList(j,3);
%         new_G(x,y,z) = PixelValues(j);
%     end
%
% for i = 1:num_images
for i = 1:10
    imwrite(new_G(:,:,i),[outpath 'Rs_' sprintf('%03d',i) '.tif']);
end