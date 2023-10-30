% Detecting rice grains

clear;
clc;

% Read an image
img = imread("rice1.png");
if size(img, 3)==1
    gray = img;
else
    gray = rgb2gray(img);
end

figure(1);
imshow(gray);

% Plot the PDF
figure(2);
imhist(gray);
title('PDF of Image');

% Thresholding
th = 128;
imgB = gray>th;

figure(3);
imshow(imgB);

% Binary filtering
se = strel('diamond', 2);       % 깎으면 붙어있는 쌀알이 없어지는 효과를 얻음.
imgB = imerode(imgB, se);
imgB = imdilate(imgB, se);      % 깎고 팽창시키면 noise 제거됨.

figure(4);
imshow(imgB);

stats = regionprops(imgB, {'Area', 'Centroid'});
tab = struct2table(stats);

% Sorting
ordered = sortrows(tab, 1, "descend");

% Show results
figure(5);
imshow(img);
hold on;
Num = 95;
title([' Detected Rices : ', num2str(Num)]);

for n=1:Num
    r = ordered.Centroid(n,1);
    c = ordered.Centroid(n,2);
    % text(r,c,num2str(n));
    text(r,c,'+','Color','red');
end

hold off;

% 인식되지 않는 쌀알을 인식하는 방안
% low pass filtering
% threshold의 값 자동제어
% remove light img filter -> 대역폭이 좁은 LPF를 써야함. filter크기를 엄청나게 큰걸로 쓰는 방법
% (가우시안, 평균필터 등, 보통은 평균필터 사용)



