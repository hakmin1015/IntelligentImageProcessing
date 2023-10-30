% 원본 이미지 로드
originalImage = imread('original_image.jpg');
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

% Edge detection using Sobel & Canny filter
edge_img = edge(outputImage, 'sobel');
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
figure(6000); imshow(imgB);

% 수정필요 area 정렬 후 크기필터링 ------------------------------------
% stats와 tab 생성
stats = regionprops(imgB, 'Area', 'Centroid');
tab = struct2table(stats);

% Sorting
ordered = sortrows(tab, 'Area', 'descend');

% stats와 tab 생성
stats = regionprops(imgB, 'Area', 'Centroid');
tab = struct2table(stats);

% Sorting
ordered = sortrows(tab, 'Area', 'descend');













% imgB를 1000x1500 크기의 다수의 블록으로 나누고, 블록별로 area가 70 이상인 세로 엣지 수가 7개 이상이면 outputImage에 그 블록의 자리에 +를 표시하는 코드

blockSize = [1000, 1500]; % 블록 크기
blockSizeY = blockSize(1);
blockSizeX = blockSize(2);

% 이미지의 크기 및 블록 수 계산
imageSize = size(imgB);
numBlocks = floor([imageSize(1) / blockSizeY, imageSize(2) / blockSizeX]);

% 블록 인식 및 개수 세기
for i = 1:numBlocks(1)
    for j = 1:numBlocks(2)
        % 현재 블록 추출
        startIndexY = (i - 1) * blockSizeY + 1;
        endIndexY = startIndexY + blockSizeY - 1;
        startIndexX = (j - 1) * blockSizeX + 1;
        endIndexX = startIndexX + blockSizeX - 1;
        block = imgB(startIndexY:endIndexY, startIndexX:endIndexX);

        % 세로 엣지 검출
        verticalEdges = sum(block, 1);

        % area가 80 이상이고 세로 엣지 수가 50개 이상인 경우
        if sum(block(:)) >= 80 && sum(verticalEdges >= 1) >= 50
            % 블록 중심 좌표 계산
            centerX = (startIndexX + endIndexX) / 2;
            centerY = (startIndexY + endIndexY) / 2;

            % 블록 중심에 + 표시
            figure(2);
            hold on;
            plot(centerX, centerY, 'r+', 'MarkerSize', 10);
            hold off;
        end
    end
end
