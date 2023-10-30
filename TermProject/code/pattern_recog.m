% 원본 이미지 로드
originalImage = imread('11111111.jpg');
originalImage = imrotate(originalImage, -90);
figure(1); imshow(originalImage);

% 4개의 점 선택
pts = ginput(4); % 사용자가 4개의 점을 찍도록 합니다.

% 주어진 4개의 점 좌표
pts1 = pts; % 원본 좌표
pts2 = [1, 1; 3024, 1; 3024, 4032; 1, 4032]; % 변환 좌표

% 원근 변환 행렬 계산
H_perspective = fitgeotrans(pts1, pts2, 'projective');

% 이미지 변환
outputImageSize = [4032, 3024];
outputImage = imwarp(originalImage, H_perspective, 'OutputView', imref2d(outputImageSize));

% 변환된 이미지 출력
figure(2); imshow(outputImage);

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

% 노란색 이미지를 그레이스케일로 변환
yellowOnlyImg_gray = rgb2gray(yellowOnlyImg);

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

figure(4); imshow(filtered_img);

yellowOnlyImg = rgb2hsv(yellowOnlyImg);
figure(5); imshow(yellowOnlyImg);

yellowOnlyImg = rgb2gray(yellowOnlyImg);
imgY = histeq(yellowOnlyImg);
figure(6); imshow(imgY);

obj = imgY(1:1+1050, 1500:1500+1500);
figure(7); imshow(obj);

img = originalImage;

patt = flipud(fliplr(obj));
patt = patt/sum(patt(:));
patt = patt - mean(patt(:));

imgR = conv2(imgY, patt, 'same');       % same option -> I/O 크기 일정
imgR = imgR/max(imgR(:));

figure(8); imshow(imgR);
% figure(9); mesh(imgR);

conv2

num = 0;
rcpnt = zeros(num,2);
threshold = 0.1;
objsize = size(obj);
radr = ceil(objsize(1)/2);
radc = ceil(objsize(2)/2);

while(num<1000)
    [maxval, r, c] = max2d(imgR);
    if maxval < threshold
        break;
    end
    num = num+1;

    rcpnt(num,1) = r;
    rcpnt(num,2) = c;
    
    % Erase
    rs = max(1, r-radr);
    re = min(size(imgR, 1), r+radr);
    cs = max(1, c-radc);
    ce = min(size(imgR, 2), c+radc);
    imgR(rs:re, cs:ce) = 0;
end

rad = radr;
color = [255, 0, 0];    % Red
imgC = DrawCross(img, rcpnt, rad, color);
figure(10); imshow(imgC);

function [maxval, r, c] = max2d(img)
[row, col] = size(img);

img = img';
vec = img(:);

[maxval, ind] = max(vec);

r = floor((ind-1)/col);
c = (ind-1) - r*col;

r = r+1;
c = c+1;
end

function [imgC] = DrawCross(img, rcpnt, rad, color)
imgC = img;
[num, wid] = size(rcpnt);

for n = 1:num
    r = rcpnt(n,1);
    c = rcpnt(n,2);
    
    imgC(r-rad:r+rad, c, 1) = color(1);
    imgC(r, c-rad:c+rad, 1) = color(1);
    
    imgC(r-rad:r+rad, c, 2) = color(2);
    imgC(r, c-rad:c+rad, 2) = color(2);
    
    imgC(r-rad:r+rad, c, 3) = color(3);
    imgC(r, c-rad:c+rad, 3) = color(3);
end
end