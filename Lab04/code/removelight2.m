clear;
clc;

% Read an image
img = imread("rice1.png");
if size(img, 3)==1
    gray = img;
else
    gray = rgb2gray(img);
end

figure(1);
imshow(gray);
title('Original Image');

% Applying Low Pass Filter
filter_size = 33;  % Filter size (odd)

% Apply the average filter
img_filtered = imfilter(gray, fspecial('average', filter_size));

figure(2);
imshow(img_filtered);
title('Filtered Image with Low Pass Filter');

figure(3);
imhist(img_filtered);
