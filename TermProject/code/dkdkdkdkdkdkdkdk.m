% 이미지 수평화 작업 및 노란색 부분 추출 완료

% perspective + yellow

% 원본 이미지 로드
originalImage = imread('11111111.jpg');
originalImage = imrotate(originalImage, -90);
figure(1); imshow(originalImage);

% 변환 전 피사체의 네 꼭지점 좌표 설정
originalPoints = [10, 800; 2824, 1500; 2824, 3532; 10, 3532];

% 변환 후 피사체의 네 꼭지점 좌표 설정 (수평한 이미지로 변환하기 위한 좌표)
transformedPoints = [10, 800; 2824, 1500; 2824, 3532; 10, 3532];

% 변환 전 피사체의 네 꼭지점 좌표를 원본 이미지에 표시
figure(1); hold on;
plot(originalPoints(:, 1), originalPoints(:, 2), '+r', 'MarkerSize', 10);
hold off;

figure(2); imshow(originalImage);
figure(2); hold on;
plot(transformedPoints(:, 1), transformedPoints(:, 2), '+r', 'MarkerSize', 10);
hold off;