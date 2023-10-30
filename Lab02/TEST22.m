clear;
clc;

imgA = imread("baboon.png");
imgB = imread("lena.png");

% specify block size
block_size = [40, 40];

% crop the images to the same size
x_offset_A = 155;
y_offset_A = 45;
x_offset_B = 250;
y_offset_B = 250;

imgA_crop = imcrop(imgA, [x_offset_A, y_offset_A, block_size(2)-1, block_size(1)-1]);
imgB_crop = imcrop(imgB, [x_offset_B, y_offset_B, block_size(2)-1, block_size(1)-1]);

if ~isequal(size(imgA_crop), size(imgB_crop))
    imgA_crop = imresize(imgA_crop, size(imgB_crop));
end

% alpha blending with cropped and resized images
[row, col, dep] = size(imgA_crop);
msksize = [row,col];
rad = min(msksize)/3;
imMsk = GaussianMask(msksize, rad);
figure;
imshow(imMsk);

% image composition
imgA_crop = double(imgA_crop);
imgB_crop = double(imgB_crop);
imgMsk = double(repmat(imMsk, [1,1,3]));
imgR = imgA_crop.*imgMsk + imgB_crop.*(1-imgMsk);

% merge the blended image and the original image
imgB(y_offset_B:y_offset_B+block_size(1)-1, x_offset_B:x_offset_B+block_size(2)-1, :) = imgR;

figure;
imshow(uint8(imgB));

function imMsk = GaussianMask(msksize, rad)
% imMsk = GaussianMask(msksize, rad)
% msksize = [row, col] of size of mask
% rad : radius for circle

rows = msksize(1);
cols = msksize(2);
center = msksize/2;

% Meshgrid
[x,y] = meshgrid(1:rows, 1:cols);

% Distance normalized by radius
dist_norm = sqrt((x-center(2)).^2 + (y-center(1)).^2)/rad;

% Gaussian mask
sigma = 0.7; % adjust this value as needed
imMsk = exp(-dist_norm.^2/(2*sigma^2));

end