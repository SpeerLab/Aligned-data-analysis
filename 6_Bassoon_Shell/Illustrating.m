input_path = 'C:\Users\Chenghang\Desktop\';
file_name = [input_path '1.tif'];
R = zeros(150,150,50,'uint8');
for k = 1:50
    currentImage = imread(file_name, k);
    R(:,:,k) = currentImage;
end 