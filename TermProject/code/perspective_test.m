% 원본 이미지 로드
originalImage1 = imread('11111111.jpg');
originalImage1 = imrotate(originalImage1, -90);
figure(1); imshow(originalImage1);

% 변환 전 피사체의 네 꼭지점 좌표 설정
originalPoints1 = [750, 1180; 1090, 1220; 1020, 1570; 600, 1540];

originalImage2 = imread('22222222.jpg');
% originalImage2 = imrotate(originalImage2, -90);
figure(2); imshow(originalImage2);

% 변환 전 피사체의 네 꼭지점 좌표 설정
originalPoints2 = [300, 480; 770, 540; 730, 1140; 190, 1080];

% 변환 전 피사체의 네 꼭지점 좌표를 원본 이미지에 표시
figure(1); hold on;
plot(originalPoints1(:, 1), originalPoints1(:, 2), '+r', 'MarkerSize', 10);
hold off;

% 변환 전 피사체의 네 꼭지점 좌표를 원본 이미지에 표시
figure(2); hold on;
plot(originalPoints2(:, 1), originalPoints2(:, 2), '+r', 'MarkerSize', 10);
hold off;