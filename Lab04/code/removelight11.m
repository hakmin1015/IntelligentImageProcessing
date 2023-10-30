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
interpolatedValues = interp1(x, gaussianCurve, 1:138, 'linear');

% Update the histogram values with the interpolated values
hist(1:138) = interpolatedValues;

% Apply modified histogram to the image
modified_gray = histeq(gray, hist);

% Display modified image
figure(3);
imshow(modified_gray);
title('Modified Image');

% Display modified histogram
figure(4);
imhist(modified_gray);

% Thresholding
th = 146;
imgB = modified_gray > th;

figure(5);
imshow(imgB);

% % Binary filtering
% se1 = strel('diamond', 2);       % 깎으면 붙어있는 쌀알이 없어지는 효과를 얻음.
% imgB = imerode(imgB, se1);
% figure(6);
% imshow(imgB);
% title('eroded Img');

% Perform binary filtering using erosion on specific regions
se = strel('diamond', 2); % Define structuring element for erosion

% Specify the regions of interest where erosion should be applied
regions = [0:256, 0:256]; % Example regions of interest

% Apply erosion only to the specified regions
for i = 1:numel(regions)
    imgB(imgB == regions(i)) = imerode(imgB(imgB == regions(i)), se);
end

figure(6);
imshow(imgB);
title('Binary Filtering Result');

% % Create a binary image component-wise connectivity
% cc = bwconncomp(imgB);
% stats = regionprops(cc, 'Area', 'Centroid');
% 
% % Set pixel values to 0 for regions with area < 2
% smallAreas = find([stats.Area] < 6);
% for i = 1:numel(smallAreas)
%     imgB(cc.PixelIdxList{smallAreas(i)}) = 0;
% end
% figure(80); imshow(imgB);

cc = bwconncomp(imgB);
stats = regionprops(cc, 'Area', 'Centroid');

% Sorting
tab = struct2table(stats);
ordered = sortrows(tab, 1, "descend");

% Show results
figure(8);
imshow(img);
hold on;
Num = 89;
title([' Detected Rices : ', num2str(Num)]);

for n = 1:Num
    r = ordered.Centroid(n,1);
    c = ordered.Centroid(n,2);
    % text(r,c,num2str(n));
    text(r, c, '+', 'Color', 'red');
end

hold off;
