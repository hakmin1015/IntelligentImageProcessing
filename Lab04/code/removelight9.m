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
hist(194) = 400;

% Interpolate values for x = 40 to 85 based on Gaussian curve
x = 1:numel(hist);
y = hist;

% Find the peak position and values
[peakValue, peakIndex] = max(hist);
peakPosition = x(peakIndex);

% Define Gaussian curve parameters based on the peak position and values
sigma = (peakPosition - 85) / 2;  % Standard deviation
mu = peakPosition;  % Mean

% Generate Gaussian curve
gaussianCurve = peakValue * exp(-(x - mu).^2 / (2*sigma^2));

% Interpolate the values for x = 40 to 85 using the Gaussian curve
interpolatedValues = interp1(x, gaussianCurve, 1:85, 'linear');

% Update the histogram values with the interpolated values
hist(1:85) = interpolatedValues;

% Apply modified histogram to the image
modified_gray = histeq(gray, hist);

% Shift the histogram by 5 units to the left
shifted_gray = circshift(modified_gray, [0, -5]);

% Display modified image
figure(3);
imshow(shifted_gray);
title('Shifted Image');

% Display modified histogram
figure(4);
imhist(shifted_gray);

% Thresholding
th = 120;
imgB = shifted_gray > th;

figure(5);
imshow(imgB);

% Binary filtering

% se2 = strel('square', 1);
% imgB = imdilate(imgB, se2);      % 깎고 팽창시키면 noise 제거됨.
% figure(100);
% imshow(imgB);
% title('first dilated Img');

se1 = strel('diamond', 2);       % 깎으면 붙어있는 쌀알이 없어지는 효과를 얻음.
imgB = imerode(imgB, se1);
figure(6);
imshow(imgB);
title('Eroded Image');

% se2 = strel('line', 4, 70);
% imgB = imdilate(imgB, se2);      % 깎고 팽창시키면 noise 제거됨.
% figure(7);
% imshow(imgB);
% title('Dilated Image');

stats = regionprops(imgB, {'Area', 'Centroid'});
tab = struct2table(stats);

% Sorting
ordered = sortrows(tab, 1, "descend");

% Show results
figure(8);
imshow(img);
hold on;
Num = 98;
title(['Detected Rices: ', num2str(Num)]);

for n = 1:Num
    r = ordered.Centroid(n, 1);
    c = ordered.Centroid(n, 2);
    % text(r,c,num2str(n));
    text(r, c, '+', 'Color', 'red');
end

hold off;
