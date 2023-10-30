clear;
clc;

fname = "Test_cir02.png";
img = imread(fname);
figure(1); imshow(img);

% Convert image to grayscale
img_gray = rgb2gray(img);

% Edge detection using Canny filter
edge_img = edge(img_gray, 'canny');

% Display the edge image
figure(2); imshow(edge_img);

imgY = double(img_gray);
obj = imgY(55:55+21, 107:107+21);
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
figure(5); mesh(imgR);

num = 0;
rcpnt = zeros(num, 2);
threshold = 0.245;
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

rad = radr;
color = [255, 0, 0];    % Red
imgC = DrawCross(img, rcpnt, rad, color);
figure(6); imshow(imgC);

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

function [imgC] = DrawCross(img, rcpnt, rad, color)
    imgC = img;
    [num, ~] = size(rcpnt);

    for n = 1:num
        r = rcpnt(n, 1);
        c = rcpnt(n, 2);

        cs = max(1, c - rad);
        ce = min(size(imgC, 2), c + rad);
        imgC(r, cs:ce, 1) = color(1);

        rs = max(1, r - rad);
        re = min(size(imgC, 1), r + rad);
        imgC(rs:re, c, 2) = color(2);

        cs = max(1, c - rad);
        ce = min(size(imgC, 2), c + rad);
        imgC(r, cs:ce, 2) = color(2);

        rs = max(1, r - rad);
        re = min(size(imgC, 1), r + rad);
        imgC(rs:re, c, 3) = color(3);

        cs = max(1, c - rad);
        ce = min(size(imgC, 2), c + rad);
        imgC(r, cs:ce, 3) = color(3);
    end
end
