clear; clc;

fname = "obj_image2.jpg";
img = imread(fname);

figure(1); imshow(img);

imgY = rgb2gray(img);
imgY = histeq(imgY);
figure(2); imshow(imgY);
figure(3); imhist(imgY);

imgY = double(imgY);
obj = imgY(40:1800+40,80:300+65);
figure(4); imshow(obj);

patt = flipud(fliplr(obj));
patt = patt/sum(patt(:));
patt = patt - mean(patt(:));

imgR = conv2(imgY(:,:,1), patt, 'same'); % imgY의 1번째 채널을 사용하여 conv2 수행
imgR = imgR/max(imgR(:));
figure(5); imshow(imgR);

% Edge detection using Canny & Canny filter
edge_img = edge(imgR, 'sobel');
edge_img = edge(edge_img, 'canny');
edge_img = edge(edge_img, 'canny');
edge_img = edge(edge_img, 'canny');
edge_img = edge(edge_img, 'canny');
figure(6); imshow(edge_img);

% Fill the edge area with white
filled_img = imfill(edge_img, 'holes');
figure(7); imshow(filled_img);

% Binary filtering
imgB = filled_img;
se = strel('line', 100, 90);
imgB = imdilate(imgB, se);
figure(8);
imshow(imgB);

stats = regionprops(imgB, {'Area', 'Centroid'});
tab = struct2table(stats);

% Sorting
ordered = sortrows(tab, 1, "descend");

% Show results
figure(9);
imshow(img);
hold on;
Num = 4;
title([' Detected Circles : ', num2str(Num)]);

for n=1:Num
 r = ordered.Centroid(n,1);
 c = ordered.Centroid(n,2);
 % text(r,c,num2str(n));
 text(r,c,'+','Color','red');
end

hold off;