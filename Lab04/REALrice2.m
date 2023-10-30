clear;
clc;

fname = "rice2.png";
img = imread(fname);
figure(1); imshow(img);

% Convert image to grayscale
img_gray = rgb2gray(img);

% Edge detection using Canny & Canny filter
edge_img = edge(img_gray, 'sobel');
edge_img = edge(edge_img, 'canny');

% Fill the edge area with white
filled_img = imfill(edge_img, 'holes');

% Display the filled image
figure(2); imshow(filled_img);

% Binary filtering
imgB = filled_img;
se = strel('diamond', 3);       % 깎으면 붙어있는 쌀알이 없어지는 효과를 얻음.
imgB = imerode(imgB, se);
imgB = imdilate(imgB, se);      % 깎고 팽창시키면 noise 제거됨.

figure(3);
imshow(imgB);

stats = regionprops(imgB, {'Area', 'Centroid'});
tab = struct2table(stats);

% Sorting
ordered = sortrows(tab, 1, "descend");

% Show results
figure(4);
imshow(img);
hold on;
Num = 14;
title([' Detected Rices : ', num2str(Num)]);

for n=1:Num
    r = ordered.Centroid(n,1);
    c = ordered.Centroid(n,2);
    % text(r,c,num2str(n));
    text(r,c,'+','Color','red');
end

hold off;