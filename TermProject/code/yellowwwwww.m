% 원본 이미지 로드
originalImage = imread('11111111.jpg');
originalImage = imrotate(originalImage, -90);
figure(1); imshow(originalImage);

% RGB 색 공간을 HSV 색 공간으로 변환
hsvImg = rgb2hsv(originalImage);

% 노란색 범위 지정
yellowHueMin = 0.05;
yellowHueMax = 0.21;
yellowSaturationMin = 0.25;
yellowValueMin = 0.25;

% 노란색 마스크 생성
yellowMask = (hsvImg(:,:,1) >= yellowHueMin & hsvImg(:,:,1) <= yellowHueMax & hsvImg(:,:,2) >= yellowSaturationMin & hsvImg(:,:,3) >= yellowValueMin);

% 마스크를 사용하여 원본 이미지에서 노란색 부분 추출
yellowOnlyImg = originalImage .* repmat(uint8(yellowMask), [1, 1, 3]);

% 결과 확인
figure(2); imshow(yellowOnlyImg);