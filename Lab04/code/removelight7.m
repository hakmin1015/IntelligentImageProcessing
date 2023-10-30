clear;
clc;

% Read an image
img = imread("rice1.png");
if size(img, 3) == 1
    gray = img;
else
    gray = rgb2gray(img);
end

figure(1);
imshow(gray);
title('Original Image');

figure(2);
hist = imhist(gray);  % Compute histogram
figure(2);
imhist(gray);

% Set histogram values below x-axis 85 to 0
hist(1:85) = 0;

% Apply modified histogram to the image
modified_gray = histeq(gray, hist);

% Display modified image
figure(3);
imshow(modified_gray);
title('Modified Image');

% Display modified histogram
figure(4);
hist_modified = imhist(modified_gray);

figure(4);
imhist(modified_gray);
