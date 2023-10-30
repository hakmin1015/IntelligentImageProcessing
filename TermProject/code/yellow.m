% yellow

clear;
clc;

fname = "11111111.jpg";
img = imread(fname);
img = imrotate(img, -90);
figure(1); imshow(img);
figure(2); imhist(img);

img = rgb2hsv(img);
% img = histeq(img);

img = rgb2gray(img);
figure(3); imshow(img);
figure(4); imhist(img);