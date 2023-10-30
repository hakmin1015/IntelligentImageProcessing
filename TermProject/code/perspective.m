% 원본 이미지 로드
originalImage = imread('11111111.jpg');
originalImage = imrotate(originalImage, -90);
figure(1); imshow(originalImage);

% 변환 전 피사체의 네 꼭지점 좌표 설정
originalPoints = [200, 800; 2400, 800; 2700, 3500; 200, 3500];

% 변환 후 피사체의 네 꼭지점 좌표 설정 (수평한 이미지로 변환하기 위한 좌표)
transformedPoints = [2000, 3000; 4000, 3000; 3000, 4000; 1500, 4000];

% 호모그래피 계산
H = fitgeotrans(originalPoints, transformedPoints, 'projective');

% 이미지 변환
outputImage = imwarp(originalImage, H);

% 변환된 이미지 출력
figure(2); imshow(outputImage);

% 변환 전 피사체의 네 꼭지점 좌표를 원본 이미지에 표시
figure(1); hold on;
plot(originalPoints(:, 1), originalPoints(:, 2), '+r', 'MarkerSize', 10);
hold off;

img = outputImage;

img = rgb2hsv(img);
img = rgb2gray(img);
figure(3); imshow(img);

% Edge detection using Sobel & Canny filter
edge_img = edge(img, 'sobel');
edge_img = edge(edge_img, 'canny');


figure(4); imshow(edge_img);

% edge_img = imfill(edge_img, 'holes');
% figure(60); imshow(edge_img);


% Binary filtering
imgB = edge_img;
se = strel('disk', 1);
imgB = imdilate(imgB, se);
figure(5); imshow(imgB);
