imgA = imread("baboon.png");
imgB = imread("lena.png");

[rowA, colA, ~] = size(imgA);
[rowB, colB, ~] = size(imgB);

% 합성할 위치 설정
xOffset = 95;  % x 방향으로의 이동 거리
yOffset = 205; % y 방향으로의 이동 거리

% 합성할 위치에서 imgA의 크기만큼의 영역 설정
startX = xOffset + 1;
startY = yOffset + 1;
endX = startX + colA - 1;
endY = startY + rowA - 1;

% 합성할 영역이 이미지 영역을 벗어나는 경우 클리핑
startX = max(startX, 1);
startY = max(startY, 1);
endX = min(endX, colB);
endY = min(endY, rowB);

msksize = [rowA, colA];
rad = min(msksize) / 28;
imMsk = CircleMask(msksize, rad);
% figure;
% imshow(imMsk);

h = [1 2 3 4 5 4 3 2 1];
h = conv(h,h);
hh = h'*h;
hh = hh/sum(hh(:));
imMsk = double(imMsk);
imMsk = imfilter(imMsk, hh);
figure;
imshow(imMsk);

% imgA를 imgB의 위치에 합성
imgA_double = im2double(imgA);
imgB_double = im2double(imgB);

% 합성할 영역에서만 연산 수행하도록 클리핑
imgB_clip = imgB_double(startY:endY, startX:endX, :);
imgA_clip = imgA_double(1:min(rowA, endY-startY+1), 1:min(colA, endX-startX+1), :);
imMsk_clip = imMsk(1:min(rowA, endY-startY+1), 1:min(colA, endX-startX+1));

imgB_clip = imgA_clip .* imMsk_clip + imgB_clip .* (1 - imMsk_clip);

% 합성된 영역을 원본 이미지에 삽입
imgB_double(startY:endY, startX:endX, :) = imgB_clip;

imgB = im2uint8(imgB_double);

figure;
imshow(imgB);


function imMsk = CircleMask(msksize, rad)
% imMsk = CircleMask(msksize, rad)
% msksize = [row, col] of size of mask
% rad : radius for circle

rows = msksize(1);
cols = msksize(2);
centerX = msksize(2) / 2.9;
centerY = msksize(1) / 8.0;

% Meshgrid
[x, y] = meshgrid(1:rows, 1:cols);

% Distance
dist = sqrt((x - centerX).^2 + (y - centerY).^2);

% Binary mask
imMsk = dist <= rad;

end
