% Gaussian Mask

clear;
clc;

imgA = imread("baboon.png");
imgB = imread("lena.png");

% create Gaussian mask
sigma = 70;
[X,Y] = meshgrid(1:size(imgA, 2), 1:size(imgA, 1));
centerX = ceil(size(imgA, 2) / 2);
centerY = ceil(size(imgA, 1) / 2);
gaussMask = exp(-((X - centerX) .^ 2 + (Y - centerY) .^ 2) ./ (2 * sigma ^ 2));

% normalize mask
gaussMask = gaussMask ./ max(gaussMask(:));

% apply mask to the circle mask
[row,col,dep] = size(imgA);
msksize = [row,col];
rad = min(msksize)/3;
imMsk = CircleMask(msksize, rad);
imMsk = imMsk .* gaussMask;
figure;
imshow(imMsk);

% image composition
imgA = double(imgA);
imgB = double(imgB);
imgMsk = double(repmat(imMsk, [1,1,3]));

imgR = imgA.*imgMsk + imgB.*(1-imgMsk);

figure;
imshow(imgR/255);

% function for creating circle mask
function imMsk = CircleMask(msksize, rad)
% imMsk = CircleMask(msksize, rad)
% msksize = [row, col] of size of mask
% rad : radius for circle

rows = msksize(1);
cols = msksize(2);
centerX = msksize(2)/2.9;
centerY = msksize(1)/7.5;

% Meshgrid
[x,y] = meshgrid(1:rows, 1:cols);

% Distance
dist = sqrt( (x-centerX).^2 + (y-centerY).^2 );

% Binary mask
imMsk = dist <= rad;

end
