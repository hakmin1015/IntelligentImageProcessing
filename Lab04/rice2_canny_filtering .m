% rice2 canny filtering

clear;
clc;

fname = "rice2.png";
img = imread(fname);
figure(1); imshow(img);

% Convert image to grayscale
img_gray = rgb2gray(img);

% Edge detection using Canny filter
edge_img = edge(img_gray, 'canny');

% Display the edge image
figure(2); imshow(edge_img);

imgY = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;
% imgY = double(img_gray);

obj = imgY(240:240+240, 320:320+100);
figure(3); imshow(obj);

patt = flipud(fliplr(obj));
patt = patt / sum(patt(:));
patt = patt - mean(patt(:));

% Enhance edge component in the pattern image
obj_edges = edge(obj, 'canny');
obj_edges = double(obj_edges);
obj_edges(obj_edges > 0) = 1;
enhanced_obj = obj_edges + obj;
enhanced_obj = enhanced_obj / max(enhanced_obj(:));
enhanced_obj = enhanced_obj - mean(enhanced_obj(:));

imgR = conv2(imgY, enhanced_obj, 'same');
imgR = imgR / max(imgR(:));

figure(4); imshow(imgR);

num = 0;
rcpnt = zeros(num, 2);
threshold = 0.8;
objsize = size(obj);
radr = ceil(objsize(1) / 2);
radc = ceil(objsize(2) / 2);

while (num < 1000)
    [maxval, r, c] = max2d(imgR);
    if maxval < threshold
        break;
    end
    num = num + 1;

    rcpnt(num, 1) = r;
    rcpnt(num, 2) = c;

    % Erase
    rs = max(1, r - radr);
    re = min(size(imgR, 1), r + radr);
    cs = max(1, c - radc);
    ce = min(size(imgR, 2), c + radc);
    imgR(rs:re, cs:ce) = 0;
end

% Show results
figure(5);
imshow(imgR);
hold on;
Num = 20;
title([' Detected Rices : ', num2str(Num)]);

for n=1:Num
    r = ordered.Centroid(n,1);
    c = ordered.Centroid(n,2);
    % text(r,c,num2str(n));
    text(r,c,'+','Color','red');
end

hold off;

function [maxval, r, c] = max2d(img)
    [row, col] = size(img);

    img = img';
    vec = img(:);

    [maxval, ind] = max(vec);

    r = floor((ind - 1) / col);
    c = (ind - 1) - r * col;

    r = r + 1;
    c = c + 1;
end