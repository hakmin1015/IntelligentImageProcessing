% 인식률 개선과 부가기능이 추가된 개선 코드 (최종 코드)
% 실행 시간이 다소 긴 편임 (약 2분 30초)

% 블록의 정보를 저장할 배열 생성
arrayBlock = zeros(1,8); % 크기가 8인 배열을 0으로 초기화

% 몇 번째 블록인지 나타내는 변수 생성
numblk = 1;

num_goblock = 0;
num_stopblock = 0;
num_notblock = 0;

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
PerspectiveSize = [4032, 3024];
PerspectiveImage = imwarp(originalImage, H_perspective, 'OutputView', imref2d(PerspectiveSize));

% 변환된 이미지 출력
figure(2); imshow(PerspectiveImage);

objImage1 = imread('obj_image1.png');
obj1 = imresize(objImage1, [1000, 1500]);
figure(3); imshow(obj1);

PerspectiveImage_gray = rgb2gray(PerspectiveImage);  % edge검출을 위해 gray이미지로 변환
figure(4); imhist(PerspectiveImage_gray);

fname = "obj_image2.jpg";
objImage2 = imread(fname);

figure(5); imshow(objImage2);

objImage2 = rgb2gray(objImage2);
objImage2 = histeq(objImage2);
figure(6); imshow(objImage2);
figure(7); imhist(objImage2);

objImage2 = double(objImage2);
obj2 = objImage2(40:1800+40,80:300+65);
figure(8); imshow(obj2);

patt = flipud(fliplr(obj2));
patt = patt/sum(patt(:));
patt = patt - mean(patt(:));

ConvImage = conv2(PerspectiveImage_gray, patt, 'same');
ConvImage = ConvImage/max(ConvImage(:));
figure(9); imshow(ConvImage);

% Edge detection using Sobel & Canny filter
EdgeImage = edge(ConvImage, 'sobel');
EdgeImage = edge(EdgeImage, 'canny');
figure(10); imshow(EdgeImage);

% Binary filtering
imgB = EdgeImage;
se1 = strel('square', 5);
imgB = imdilate(imgB, se1);
figure(11); imshow(imgB);

se2 = strel('line', 120, 90);
imgB = imerode(imgB, se2);
imgB = imdilate(imgB, se2);
figure(12); imshow(imgB);

% edge의 area 크기를 내림차순으로 정렬
stats = regionprops(imgB, {'Area', 'Centroid'});
tab = struct2table(stats);

% Sorting
ordered = sortrows(tab, 1, "descend");

edge_threshold = 5000;
% area 크기가 edge_threshold 이하인 엣지의 센터 좌표를 추출하여 +표시 후 제거
smallEdges = tab(tab.Area <= edge_threshold, :);
centerCoords = round(smallEdges.Centroid);

figure(12);
hold on;
plot(centerCoords(:, 1), centerCoords(:, 2), 'r+', 'MarkerSize', 10);
hold off;

% 빨간색 "+"로 표시된 엣지를 0으로 만들기
imgR = bwareaopen(imgB, edge_threshold);

% 수정된 이미지 출력
figure(13);
imshow(imgR);

% imgR을 1000x1500 크기의 다수의 블록으로 나누고
% 블록별로 세로 엣지 수가 50개 이상이면
% PerspectiveImage에 그 블록의 자리에 +를 표시하는 코드

blockSize = [1000, 1500]; % 블록 크기
blockSizeY = blockSize(1);
blockSizeX = blockSize(2);

% 이미지의 크기 및 블록 수 계산
imageSize = size(imgR);
numBlocks = floor([imageSize(1) / blockSizeY, imageSize(2) / blockSizeX]);

% 블록 인식 및 개수 세기
for i = 1:numBlocks(1)
    for j = 1:numBlocks(2)
        % 현재 블록 추출
        startIndexY = (i - 1) * blockSizeY + 1 + (8*(i-1));
        endIndexY = startIndexY + blockSizeY - 1;
        startIndexX = (j - 1) * blockSizeX + 1 + (12*(j-1));
        endIndexX = startIndexX + blockSizeX - 1;
        block1 = PerspectiveImage(startIndexY:endIndexY, startIndexX:endIndexX);

        % STOP 블록 검출
        % 템플릿 매칭 수행
        similarity = normxcorr2(obj1(:,:,1), block1(:,:,1)); % 빨간 채널만 사용
        
        % 매칭 결과를 기반으로 블록 인식
        patt_threshold = 0.23;  % 임계값 설정
        [maxValue, ~] = max(similarity(:));
        
        if maxValue > patt_threshold 
            arrayBlock(numblk) = 0;

            % 같은 패턴의 블록을 빨간색 "+"로 표시
            centerX = (startIndexX + endIndexX) / 2;
            centerY = (startIndexY + endIndexY) / 2;
            figure(2);
            hold on;
            plot(centerX, centerY, 'rx', 'MarkerSize', 30);
            hold off;
        
        block2 = imgR(startIndexY:endIndexY, startIndexX:endIndexX);
        % GO 블록 검출
        % 세로 엣지 검출
        verticalEdges = sum(block2, 1);

        % 세로 엣지 수가 42개 이상인 경우
        elseif sum(verticalEdges >= 1) >= 42
            % 블록 중심 좌표 계산
            centerX = (startIndexX + endIndexX) / 2;
            centerY = (startIndexY + endIndexY) / 2;

            % 블록 중심에 + 표시
            figure(2);
            hold on;
            plot(centerX, centerY, 'r+', 'MarkerSize', 20);
            hold off;

            % Go 블록이면 arrayBlock에 1을 저장
            arrayBlock(numblk) = 1;

        else
            arrayBlock(numblk) = -1;
        end
        numblk = numblk + 1;
    end
end

numblk = numblk - 1;

for i = 1:(numblk)
    if arrayBlock(i) == 1
        num_goblock = num_goblock + 1;

    elseif arrayBlock(i) == 0
        num_stopblock = num_stopblock + 1;

    else
        num_notblock = num_notblock + 1;

    end
end

disp(['Go 블록 개수: ', num2str(num_goblock)]);
disp(['Stop 블록 개수: ', num2str(num_stopblock)]);
disp(['점자블록이 아닌 개수: ', num2str(num_notblock)])

for i = 1:(numblk)
    if arrayBlock(i) == 1
        disp([num2str(i) ,'번째 블록은 Go 블록입니다.']);

    elseif arrayBlock(i) == 0
        disp([num2str(i) ,'번째 블록은 Stop 블록입니다.']);

    else
        disp([num2str(i) ,'번째 블록은 점자블록이 아닙니다.']);

    end
end

cnt1 = 0;
cnt2 = 0;

for i = numblk:-2:1
    if arrayBlock(i) == 0
        break;
    else
        cnt1 = cnt1 + 1;
    end
end

for i = (numblk-1):-2:1
    if arrayBlock(i) == 0
        break;
    else
        cnt2 = cnt2 + 1;
    end
end

if cnt1 == cnt2
    disp(['앞으로', num2str(cnt1) ,'블록 만큼 걸어가다 멈추세요.']);
else
    disp(['앞으로 ', num2str(cnt1),'에서 ' num2str(cnt2) ,'블록 만큼 걸어가다 멈추세요.']);
end
