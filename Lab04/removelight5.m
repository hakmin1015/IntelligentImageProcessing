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
imhist(gray);
title('Original Image Histogram');

% Applying Gaussian Filter within the range of 0~120 in the histogram
filter_size = 999;  % Filter size (odd)
sigma = 50;  % Standard deviation for the Gaussian filter
hist_range = 0:120;     % 120 넘어가면 안됨

% Create a mask for values outside the desired range
mask = ~(gray >= hist_range(1) & gray <= hist_range(end));

% Apply the Gaussian filter only to the pixels within the desired range
gray1 = gray;
gray1(~mask) = imgaussfilt(gray(~mask), sigma, 'FilterSize', filter_size);

% repeat
% Applying Gaussian Filter within the range of 121~255 in the histogram
filter_size = 999;  % Filter size (odd)
sigma = 50;  % Standard deviation for the Gaussian filter
hist_range = 200:255;

% Create a mask for values outside the desired range
mask = ~(gray1 >= hist_range(1) & gray1 <= hist_range(end));

% Apply the Gaussian filter only to the pixels within the desired range
img_filtered = gray1;
img_filtered(~mask) = imgaussfilt(gray1(~mask), sigma, 'FilterSize', filter_size);

% Apply average filter to the entire x-axis of the histogram
average_filter_size = 3;  % Filter size for average filter
average_filter = ones(1, average_filter_size) / average_filter_size;
img_filtered = imfilter(img_filtered, average_filter, 'replicate');

figure(3);
imshow(img_filtered);
title('Filtered Image with Gaussian and Average Filters');

figure(4);
imhist(img_filtered);
title('Filtered Image Histogram');

% Thresholding
th = 110;
imgB = img_filtered > th;

figure(5);
imshow(imgB);

% Binary filtering
se1 = strel('diamond', 2);       % 깎으면 붙어있는 쌀알이 없어지는 효과를 얻음.
imgB = imerode(imgB, se1);
figure(6);
imshow(imgB);
title('eroded Img');

se2 = strel('square', 2);
imgB = imdilate(imgB, se2);      % 깎고 팽창시키면 noise 제거됨.
figure(7);
imshow(imgB);
title('dilated Img');

stats = regionprops(imgB, {'Area', 'Centroid'});
tab = struct2table(stats);

% Sorting
ordered = sortrows(tab, 1, "descend");

% Show results
figure(8);
imshow(img);
hold on;
Num = 90;
title([' Detected Rices : ', num2str(Num)]);

for n = 1:Num
    r = ordered.Centroid(n,1);
    c = ordered.Centroid(n,2);
    % text(r,c,num2str(n));
    text(r, c, '+', 'Color', 'red');
end

hold off;
