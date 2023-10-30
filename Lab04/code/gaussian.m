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

% Apply Gaussian filter
filtered = imgaussfilt(gray, 2); % 2는 가우시안 필터 크기입니다. 필터 크기를 조정해야 할 수도 있습니다.

figure(2);
imshow(filtered);

% Thresholding
th = 128;
imgB = filtered > th;

figure(3);
imshow(imgB);

% Binary filtering
se = strel('diamond', 2);
imgB = imerode(imgB, se);
imgB = imdilate(imgB, se);

figure(4);
imshow(imgB);

stats = regionprops(imgB, {'Area', 'Centroid'});
tab = struct2table(stats);

% Sorting
ordered = sortrows(tab, 1, "descend");

% Show results
figure(5);
imshow(img);
hold on;
Num = 20;
title([' Detected Rices : ', num2str(Num)]);

for n = 1:Num
    r = ordered.Centroid(n,1);
    c = ordered.Centroid(n,2);
    % text(r,c,num2str(n));
    text(r,c,'+','Color','red');
end

hold off;
