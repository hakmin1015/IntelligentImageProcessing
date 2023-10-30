% histogram_stretching

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

% Plot the PDF
figure(2);
imhist(gray);
title('PDF of Image');

% Thresholding
th = 128;
imgB = gray > th;

figure(3);
imshow(imgB);

% Binary filtering
se = strel('diamond', 2);
imgB = imerode(imgB, se);
imgB = imdilate(imgB, se);

figure(4);
imshow(imgB);

% Histogram stretching
lowerBound = 50;  % 삭제할 하한 값
upperBound = 200; % 삭제할 상한 값

% 히스토그램 스트레칭을 위한 새로운 범위 계산
oldRange = upperBound - lowerBound;
newMin = 0;
newMax = 255;

% 히스토그램 스트레칭 적용
imgAdjusted = imadjust(gray, [lowerBound/255 upperBound/255], [newMin/255 newMax/255]);

figure(5);
imshow(imgAdjusted);
title('Adjusted Image');

% Thresholding on adjusted image
thAdjusted = 128;
imgBAdjusted = imgAdjusted > thAdjusted;

figure(6);
imshow(imgBAdjusted);

% Binary filtering on adjusted image
imgBAdjusted = imerode(imgBAdjusted, se);
imgBAdjusted = imdilate(imgBAdjusted, se);

figure(7);
imshow(imgBAdjusted);

% Rice detection
stats = regionprops(imgBAdjusted, {'Area', 'Centroid'});
tab = struct2table(stats);

ordered = sortrows(tab, 'Area', 'descend');

% Show results
figure(7);
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
