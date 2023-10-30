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

% 변환 전 피사체의 네 꼭지점 좌표를 원본 이미지에 표시
figure(1); hold on;
plot(originalPoints(:, 1), originalPoints(:, 2), '+r', 'MarkerSize', 10);
hold off;

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
yellowOnlyImg = outputImage .* uint8(yellowMask);

% 결과 확인
figure(3); imshow(yellowOnlyImg);

% 사용자로부터 일부분 선택
rect = getrect; % 사용자가 사각형 영역을 선택하도록 합니다.

% 선택된 영역 좌표
x = round(rect(1));
y = round(rect(2));
width = round(rect(3));
height = round(rect(4));

% 선택된 영역 확대하여 추출
zoomedArea = imcrop(yellowOnlyImg, [x, y, width, height]);

% 확대된 영역 출력
figure(4); imshow(zoomedArea);

% 3차원 이미지를 2D로 변환
yellowOnlyImg_gray = rgb2gray(zoomedArea);

% 잡음 제거를 위한 미디언 필터 적용
filtered_img = medfilt2(yellowOnlyImg_gray, [4, 4]); % 필터 크기는 적절하게 조정 가능

% 영역 분할 수행
cc = bwconncomp(filtered_img);
areas = regionprops(cc, 'Area');
areas = [areas.Area];

% 영역의 크기에 따라 내림차순으로 정렬
[sortedAreas, sortedIndices] = sort(areas, 'descend');

% 특정 크기보다 작은 영역 제거
minAreaThreshold = 1200; % 적절한 값으로 설정
for i = 1:numel(sortedIndices)
    if sortedAreas(i) < minAreaThreshold
        filtered_img(cc.PixelIdxList{sortedIndices(i)}) = 0;
    end
end

figure(5); imshow(filtered_img);

% Edge detection using Sobel & Canny filter
edge_img = edge(filtered_img, 'sobel');
edge_img = edge(edge_img, 'canny');

figure(6); imshow(edge_img);

% edge_img = imfill(edge_img, 'holes');
% figure(7); imshow(edge_img);

% % Binary filtering
% imgB = edge_img;
% se = strel('disk', 1);
% imgB = imerode(imgB, se);
% % imgB = imdilate(imgB, se);
% figure(8); imshow(imgB);