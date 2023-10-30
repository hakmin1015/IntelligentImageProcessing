inputImage = imread('11111111.jpg');
inputImage = imrotate(inputImage, -90);


% 원근 변환에 사용할 원본 점과 목표 점 정의
sourcePoints = [1, 1; 3024, 1; 3024, 4032; 1, 4032]; % 원본 이미지의 네 점의 좌표
targetPoints = [1000, 3000; 3000, 3000; 2150, 4000; 1650, 4000]; % 목표 이미지의 네 점의 좌표

% 원근 변환 행렬 계산
tform = cp2tform(sourcePoints, targetPoints, 'projective');

% 원근 변환 적용
outputImage = imtransform(inputImage, tform);
figure(1); imshow(outputImage);