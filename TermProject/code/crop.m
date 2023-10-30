% 원본 이미지 불러오기
originalImage = imread('11111111.jpg');
originalImage = imrotate(originalImage, -90);
figure(1);
imshow(originalImage);
title('원본 이미지');

% 잘라낼 부분 선택
figure(2);
imshow(originalImage);
title('잘라낼 부분 선택');
rect = getrect; % 마우스로 사각형 영역 선택 (왼쪽 위 모서리 좌표와 가로 세로 크기 반환)
close(2);

% 선택한 부분 잘라내기
croppedImage = imcrop(originalImage, rect);
figure(3);
imshow(croppedImage);
title('잘라낸 이미지');

% % 잘라낸 이미지 크기를 원본 이미지와 동일하게 조정
% resizedImage = imresize(croppedImage, size(originalImage, [1 2]));
% figure(4);
% imshow(resizedImage);
% title('크기 조정된 이미지');

% 원근 변환을 위한 좌표 설정
originalPoints = [rect(1), rect(2); rect(1)+rect(3), rect(2); rect(1)+rect(3), rect(2)+rect(4); rect(1), rect(2)+rect(4)];
targetPoints = [1, 1; size(originalImage, 2), 1; size(originalImage, 2), size(originalImage, 1); 1, size(originalImage, 1)];

% 원근 변환 행렬 계산
tform = cp2tform(originalPoints, targetPoints, 'projective');

% 원근 변환 적용
outputImage = imtransform(croppedImage, tform, 'XData', [1 size(originalImage, 2)], 'YData', [1 size(originalImage, 1)]);

% 결과 이미지 출력
figure(5);
imshow(outputImage);
title('원근 변환된 이미지');
