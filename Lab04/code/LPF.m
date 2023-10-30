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

% Plot the PDF
imhist(gray);
title('PDF of Image');

% Thresholding
th = 128;
imgB = gray > th;

figure(2);
imshow(imgB);

% Binary filtering
se = strel('diamond', 2);
imgB = imerode(imgB, se);
imgB = imdilate(imgB, se);

figure(3);
imshow(imgB);

stats = regionprops(imgB, {'Area', 'Centroid'});
tab = struct2table(stats);

ordered = sortrows(tab, 1, "descend");

% Low Pass Filter (Average Filter)
filterSize = 10; % Size of the average filter
filter = fspecial('average', filterSize);
imgFiltered = imfilter(img, filter);

% Show results
figure(4);
imshow(imgFiltered);
title('Filtered Image');

figure(5);
imshow(img);
hold on;
Num = 20;
title(['Detected Rices: ', num2str(Num)]);

for n = 1:Num
    r = ordered.Centroid(n, 1);
    c = ordered.Centroid(n, 2);
    text(r, c, '+', 'Color', 'red');
end

hold off;