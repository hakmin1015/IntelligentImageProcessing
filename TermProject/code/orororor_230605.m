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
PerspectiveSize = [4032, 3024];
PerspectiveImage = imwarp(originalImage, H_perspective, 'OutputView', imref2d(PerspectiveSize));

% 변환된 이미지 출력
figure(2); imshow(PerspectiveImage);

fname = "1_8.png";
img = imread(fname);

figure(1); imshow(img);

imgY = rgb2hsv(img);
imgY = rgb2gray(img);
imgY = histeq(imgY);
figure(20); imshow(imgY);
figure(10); imhist(imgY);

imgY = double(imgY);
obj = imgY(75:75+65,80:80+65);
figure(2); imshow(obj);

patt = flipud(fliplr(obj));
patt = patt/sum(patt(:));
patt = patt - mean(patt(:));

imgR = conv2(PerspectiveImage(:,:,1), patt, 'same');       % imgY의 1번째 채널을 사용하여 conv2 수행
imgR = imgR/max(imgR(:));

figure(3); imshow(imgR);

% Edge detection using Canny & Canny filter
edge_img = edge(imgR, 'sobel');
edge_img = edge(edge_img, 'canny');
edge_img = edge(edge_img, 'canny');
edge_img = edge(edge_img, 'canny');
edge_img = edge(edge_img, 'canny');

figure(4); imshow(edge_img);

se = strel('square', 3);
edge_img = imdilate(edge_img, se);

% Fill the edge area with white
filled_img = imfill(edge_img, 'holes');

% Display the filled image
figure(2); imshow(filled_img);

% Binary filtering
imgB = filled_img;
se = strel('disk', 8);
imgB = imerode(imgB, se);
imgB = imdilate(imgB, se);

figure(80);
imshow(imgB);

stats = regionprops(imgB, {'Area', 'Centroid'});
tab = struct2table(stats);

% Sorting
ordered = sortrows(tab, 1, "descend");

% Show results
figure(5);
imshow(img);
hold on;
Num = 36;
title([' Detected Dot Blockes : ', num2str(Num)]);

for n=1:Num
    r = ordered.Centroid(n,1);
    c = ordered.Centroid(n,2);
    % text(r,c,num2str(n));
    text(r,c,'+','Color','red');
end

hold off;