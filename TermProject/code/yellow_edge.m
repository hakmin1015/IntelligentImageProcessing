% yellow

clear;
clc;

fname = "11111111.jpg";
img = imread(fname);
img = imrotate(img, -90);
figure(1); imshow(img);

img = rgb2hsv(img);
img = rgb2gray(img);
figure(3); imshow(img);

% Edge detection using Sobel & Canny filter
edge_img = edge(img, 'sobel');
edge_img = edge(edge_img, 'canny');


figure(4); imshow(edge_img);

% edge_img = imfill(edge_img, 'holes');
% figure(60); imshow(edge_img);


% Binary filtering
imgB = edge_img;
se = strel('disk', 2);
imgB = imdilate(imgB, se);
figure(5); imshow(imgB);

% imgB = edge_img;
% se = strel('square', 1);
% imgB = imerode(imgB, se);
% figure(6); imshow(imgB);

