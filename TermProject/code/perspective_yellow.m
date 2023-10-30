% 원본 이미지 로드
originalImage = imread('11111111.jpg');
originalImage = imrotate(originalImage, -90);
figure(1); imshow(originalImage);

% 변환 전 피사체의 네 꼭지점 좌표 설정
originalPoints = [1, 1; 3024, 1; 3024, 4032; 1, 4032];

% 변환 후 피사체의 네 꼭지점 좌표 설정 (수평한 이미지로 변환하기 위한 좌표)
transformedPoints = [1000, 3000; 3000, 3000; 2150, 4000; 1650, 4000];

% 호모그래피 계산
H = fitgeotrans(originalPoints, transformedPoints, 'projective');

% 이미지 변환
outputImage = imwarp(originalImage, H);

% 변환된 이미지 출력
figure(2); imshow(outputImage);

% % 변환 전 피사체의 네 꼭지점 좌표를 원본 이미지에 표시
% figure(1); hold on;
% plot(originalPoints(:, 1), originalPoints(:, 2), '+r', 'MarkerSize', 10);
% hold off;


% RGB 색 공간을 HSV 색 공간으로 변환
hsvImg = rgb2hsv(outputImage);

% 노란색 범위 지정
yellowHueMin = 0.05;
yellowHueMax = 0.21;
yellowSaturationMin = 0.25;
yellowValueMin = 0.25;

% 노란색 마스크 생성
yellowMask = (hsvImg(:,:,1) >= yellowHueMin & hsvImg(:,:,1) <= yellowHueMax & hsvImg(:,:,2) >= yellowSaturationMin & hsvImg(:,:,3) >= yellowValueMin);

% 마스크를 사용하여 원본 이미지에서 노란색 부분 추출
yellowOnlyImg = outputImage .* repmat(uint8(yellowMask), [1, 1, 3]);

% 결과 확인
figure(3); imshow(yellowOnlyImg);

