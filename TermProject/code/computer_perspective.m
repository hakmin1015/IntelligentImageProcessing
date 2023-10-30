% 이미지 로드
img = imread('test_monitor.jpg');

% 원본 이미지 출력
figure;
imshow(img);
title('Original Image');
hold on;

% 4개의 점 선택
pts = ginput(4); % 사용자가 4개의 점을 찍도록 합니다.

% 주어진 4개의 점 좌표
pts1 = pts; % 원본 좌표
pts2 = [1, 1; 4032, 1; 4032, 3024; 1, 3024]; % 변환 좌표

% 원근 변환 행렬 계산
H_perspective = fitgeotrans(pts1, pts2, 'projective');

% 이미지 변환
outputImageSize = [3024, 4032];
img2 = imwarp(img, H_perspective, 'OutputView', imref2d(outputImageSize));

% 시각화
figure;
subplot(1, 2, 1);
imshow(img);
title('Original');
hold on;
scatter(pts1(:, 1), pts1(:, 2), 'r', 'filled');
hold off;

subplot(1, 2, 2);
imshow(img2);
title('Perspective Transformed');
hold on;
scatter(pts2(:, 1), pts2(:, 2), 'w');
hold off;
