imgA = imread("baboon.png");
imgB = imread("lena.png");

[row, col, dep] = size(imgA);
msksize = [row, col];
rad = min(msksize) / 3;
imMsk = TriangleMask(msksize, rad);

% 주기와 진폭 설정
period = 2 * rad;
amplitude = 10;

% 삼각파 함수 구현
center = msksize / 2;
[x, y] = meshgrid(1:col, 1:row);
dist = sqrt((x - center(2)).^2 + (y - center(1)).^2);
imMsk = (dist <= rad) .* (1 - dist / rad);

figure;
imshow(imMsk);

% image composition
imgA = double(imgA);
imgB = double(imgB);
imgMsk = double(repmat(imMsk, [1, 1, 3]));

imgR = imgA .* imgMsk + imgB .* (1 - imgMsk);

figure;
imshow(imgR/255);

function imMsk = TriangleMask(msksize, rad)
% imMsk = TriangleMask(msksize, rad)
% msksize = [row, col] of size of mask
% rad : radius for triangle mask

rows = msksize(1);
cols = msksize(2);
center = msksize / 2;

% Meshgrid
[x, y] = meshgrid(1:cols, 1:rows);

% Distance
dist = sqrt((x - center(2)).^2 + (y - center(1)).^2);

% Triangle mask
imMsk = (dist >= rad) .* 0 + (dist < rad) .* (1 - dist / rad);

end