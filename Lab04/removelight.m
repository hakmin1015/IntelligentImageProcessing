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

figure(2);
imhist(gray);
title('Original Image Histogram');

% Applying Low Pass Filter within the range of 0~60 in the histogram
filter_size = 161;  % Filter size (odd)
hist_range = 0:180;

% Create a mask for values outside the desired range
mask = ~(gray >= hist_range(1) & gray <= hist_range(end));

% Apply the average filter only to the pixels within the desired range
img_filtered = gray;
img_filtered(~mask) = imfilter(gray(~mask), fspecial('average', filter_size), 'replicate');

figure(3);
imshow(img_filtered);
title('Filtered Image with Low Pass Filter (0-60 Range)');

figure(4);
imhist(img_filtered);
title('Filtered Image Histogram');