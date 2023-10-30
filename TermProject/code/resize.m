% 이미지 불러오기
image = imread('11111111.jpg');
image = imrotate(image, -90);

% 이미지 일부 자르기
x = 1000;    % 자를 영역의 x 좌표
y = 1000;    % 자를 영역의 y 좌표
width = 800;   % 자를 영역의 너비
height = 800;  % 자를 영역의 높이
croppedImage = imcrop(image, [x, y, width, height]);

% 이미지 크기 키우기
scale = 4;  % 이미지를 2배 확대
resizedImage = imresize(croppedImage, scale);

% 결과 확인
imshow(resizedImage);
