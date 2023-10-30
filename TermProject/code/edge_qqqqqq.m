% 원본 이미지 로드
originalImage = imread('11111111.jpg');
originalImage = imrotate(originalImage, -90);
figure(1); imshow(originalImage);

% 4개의 점 선택
% pts = ginput(4); % 사용자가 4개의 점을 찍도록 합니다.

% 주어진 4개의 점 좌표
% pts1 = pts;
pts1 = [1020, 1570; 1840, 1600; 2130, 3170; 750, 3120]; % 원본 좌표
pts2 = [1, 1; 3024, 1; 3024, 4032; 1, 4032]; % 변환 좌표

% 이미지에 좌표 표시
figure(1);
hold on;
plot(pts1(:, 1), pts1(:, 2), 'r+', 'MarkerSize', 10);
hold off;

% 원근 변환 행렬 계산
H_perspective = fitgeotrans(pts1, pts2, 'projective');

% 이미지 변환
outputImageSize = [4032, 3024];
outputImage = imwarp(originalImage, H_perspective, 'OutputView', imref2d(outputImageSize));
% outputImage = histeq(outputImage);

% 변환된 이미지 출력
figure(2); imshow(outputImage);

outputImage = rgb2gray(outputImage);
hist = imhist(outputImage);  % Compute histogram
figure(112);
imhist(outputImage);

% Set histogram values below x-axis 50 to 0
hist(1:130) = 0;
figure(12);
imhist(outputImage);


% Interpolate values for x = 1 to 130 based on Gaussian curve
x = 1:numel(hist);
y = hist;

% Find the peak position and values
[peakValue, peakIndex] = max(hist);
peakPosition = x(peakIndex);

% Define Gaussian curve parameters based on the peak position and values
sigma = (peakPosition - 180) / 2;  % Standard deviation
mu = peakPosition;  % Mean

% Generate Gaussian curve
gaussianCurve = peakValue * exp(-(x - mu).^2 / (2*sigma^2));

% Interpolate the values for x = 1 to 50 using the Gaussian curve
interpolatedValues = interp1(x, gaussianCurve, 1:255, 'linear');

% Update the histogram values with the interpolated values
hist(1:255) = interpolatedValues;

% Apply modified histogram to the image
modified_gray = histeq(outputImage, hist);

% Display modified image
figure(3);
imshow(modified_gray);
title('Modified Image');

% Display modified histogram
figure(4);
imhist(modified_gray);

modified_gray = imgaussfilt(modified_gray, 2);

% % outputImage = rgb2gray(outputImage);
% % figure(500); imshow(outputImage);


% Edge detection using Sobel & Canny filter
edge_img = edge(modified_gray, 'sobel');
edge_img = edge(edge_img, 'canny');

figure(50); imshow(edge_img);


imgB = edge_img;
se = strel('square', 5);
imgB = imdilate(imgB, se);
figure(6); imshow(imgB);

edge_img = imfill(edge_img, 'holes');
figure(60); imshow(edge_img);

% Binary filtering
se = strel('line', 120, 90);
imgB = imerode(imgB, se);
imgB = imdilate(imgB, se);
figure(6); imshow(imgB);