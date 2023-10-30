% rice1 histogram editing

clc;
clear;

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
figure(2);
imhist(gray);
title('PDF of Image');

% Apply Gaussian function to modify histogram
histVals = imhist(gray);
x = 0:255; % x-axis values
meanVal = 105; % mean value for Gaussian distribution
sigmaVal = 15; % standard deviation for Gaussian distribution
gaussianWeight = exp(-((x - meanVal).^2) / (2 * sigmaVal^2));
modifiedHist = histVals;
modifiedHist(x >= 0 & x <= 105) = histVals(x >= 00 & x <= 105) .* gaussianWeight(x >= 0 & x <= 105)';
figure(3);
bar(modifiedHist);
title('Modified PDF of Image');

% Apply modified histogram to the image
imgModified = gray;
for i = 1:size(gray, 1)
for j = 1:size(gray, 2)
pixelVal = gray(i, j) + 1;
imgModified(i, j) = modifiedHist(pixelVal);
end
end

figure(4);
imshow(imgModified);
title('Modified Image');

% Thresholding
th = 128;
imgB = imgModified > th;

figure(5);
imshow(imgB);

% Binary filtering
se = strel('diamond', 2);
imgB = imerode(imgB, se);
imgB = imdilate(imgB, se);

figure(6);
imshow(imgB);

stats = regionprops(imgB, {'Area', 'Centroid'});
tab = struct2table(stats);

ordered = sortrows(tab, 1, "descend");

% Show results
figure(7);
imshow(imgModified);
hold on;
Num = 20;
title(['Detected Rices: ', num2str(Num)]);

for n = 1:Num
r = ordered.Centroid(n, 1);
c = ordered.Centroid(n, 2);
text(r, c, '+', 'Color', 'red');
end

hold off;