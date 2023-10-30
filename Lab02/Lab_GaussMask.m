clear;
clc;

imgA = imread("baboon.png");
imgB = imread("lena.png");

[row,col,dep] = size(imgA);
msksize = [row,col];
sig = min(msksize)/6;
imMsk = GaussMask(msksize, sig);
figure;
imshow(imMsk);

% image composition
imgA = double(imgA);
imgB = double(imgB);
imgMsk = double(repmat(imMsk, [1,1,3]));    % gray영상을 RGB영상으로 바꿀 때 사용하는 함수

imgR = imgA.*imgMsk + imgB.*(1-imgMsk);

figure;
imshow(imgR/255);

function imMsk = GaussMask(msksize, sig)
% imMsk = CircleMask(msksize, rad)
% msksize = [row, col] of size of mask
% sig : sigma for gaussian function

rows = msksize(1);
cols = msksize(2);
center = msksize/2;

% Meshgrid
[x,y] = meshgrid(1:rows, 1:cols);

% Distance
% exp(- (x^2 + y^2)/2*sigma^2 )
dist = exp( -((x-center(2)).^2 + (y-center(1)).^2) / (2*sig^2) );

% Gaussian mask
imMsk = dist/max(dist(:));

end