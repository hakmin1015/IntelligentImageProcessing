% Test1

clear;
clc;

imgA = imread("baboon.png");
imgB = imread("lena.png");

[row,col,dep] = size(imgA);
msksize = [row,col];
rad = min(msksize)/20;
imMsk = CircleMask(msksize, rad);
figure;
imshow(imMsk);

% image composition
imgA = double(imgA);
imgB = double(imgB);
imgMsk = double(repmat(imMsk, [1,1,3]));    % gray영상을 RGB영상으로 바꿀 때 사용하는 함수

imgR = imgA.*imgMsk + imgB.*(1-imgMsk);

figure;
imshow(imgR/255);



function imMsk = CircleMask(msksize, rad)
% imMsk = CircleMask(msksize, rad)
% msksize = [row, col] of size of mask
% rad : radius for circle

rows = msksize(1);
cols = msksize(2);
centerX = msksize(2)/2.9;
centerY = msksize(1)/7.8;

% Meshgrid
[x,y] = meshgrid(1:rows, 1:cols);

% Distance
dist = sqrt( (x-centerX).^2 + (y-centerY).^2 );

% Binary mask
imMsk = dist <= rad;

end



