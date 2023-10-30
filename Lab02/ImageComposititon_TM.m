imgA = imread("baboon.png");
imgB = imread("lena.png");

[rowA, colA, ~] = size(imgA);
[rowB, colB, ~] = size(imgB);

% 합성할 위치 설정
xOffset = 95; % x 방향으로의 이동 거리
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
rad = min(msksize) / 25;
imMsk = TriangleMask(msksize, rad);
figure;
imshow(imMsk);

% imgA의 특정 부분 추출
imgA_clip = imgA(1:min(rowA, endY-startY+1), 1:min(colA, endX-startX+1), :);

% imgA를 imgB의 위치에 합성
imgA_double = double(imgA_clip);
imgB_double = double(imgB);

% 합성할 영역에서만 연산 수행하도록 클리핑
imgB_clip = imgB_double(startY:endY, startX:endX, :);
imMsk_clip = imMsk(1:min(rowA, endY-startY+1), 1:min(colA, endX-startX+1));

imgB_clip = imgA_double .* imMsk_clip + imgB_clip .* (1 - imMsk_clip);

% 합성된 영역을 원본 이미지에 삽입
imgB_double(startY:endY, startX:endX, :) = imgB_clip;

imgB = uint8(imgB_double);

figure;
imshow(imgB);

function imMsk = TriangleMask(msksize, rad)
% imMsk = TriangleMask(msksize, rad)
% msksize = [row, col] of size of mask
% rad : radius for triangle mask

rows = msksize(1);
cols = msksize(2);
centerX = msksize(2) / 2.9;
centerY = msksize(1) / 8.0;

% Meshgrid
[x, y] = meshgrid(1:cols, 1:rows);

% Distance
dist = sqrt((x - centerX).^2 + (y - centerY).^2);

% Triangle mask
imMsk = (dist >= rad) .* 0 + (dist < rad) .* (1 - dist / rad);

end