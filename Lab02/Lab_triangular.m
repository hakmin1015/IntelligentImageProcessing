clear;
clc;

imgA = imread("baboon.png");
imgB = imread("lena.png");


[row,col,dep] = size(imgA);
msksize = [row,col];
rad = min(msksize)/3;
imMsk = CircleMask(msksize, rad);

% 주기와 진폭 설정
period = 2 * rad;
amplitude = 1;

% 삼각파 함수 구현
imMsk = amplitude * (1 + sin(2*pi*dist/period))/2;

figure;
imshow(imMsk);

% image composition
imgA = double(imgA);
imgB = double(imgB);
imgMsk = double(repmat(imMsk, [1,1,3]));

imgR = imgA.*imgMsk + imgB.*(1-imgMsk);

figure;
imshow(imgR/255);


function imMsk = CircleMask(msksize, rad)
% imMsk = CircleMask(msksize, rad)
% msksize = [row, col] of size of mask
% rad : radius for circle

rows = msksize(1);
cols = msksize(2);
center = msksize/2;

% Meshgrid
[x,y] = meshgrid(1:rows, 1:cols);

% Distance
dist = sqrt( (x-center(2)).^2 + (y-center(1)).^2 );

% 주기와 진폭 설정
period = 2 * rad;
amplitude = 1;

% 삼각파 함수 구현
imMsk = amplitude * (1 + sin(2*pi*dist/period))/2;

end