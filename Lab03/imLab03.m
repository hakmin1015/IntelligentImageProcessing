% Pattern recognition via convolution

clear;
clc;

fname = "Test_cir02.png";
img = imread(fname);
figure(1); imshow(img);

imgY = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;
imgY = double(imgY);
obj = imgY(57:57+21,108:108+21);
figure(2); imshow(obj);

patt = flipud(fliplr(obj));
patt = patt/sum(patt(:));
patt = patt - mean(patt(:));

imgR = conv2(imgY, patt, 'same');       % same option -> I/O 크기 일정
imgR = imgR/max(imgR(:));

figure(3); imshow(imgR);
figure(4); mesh(imgR);

num = 0;
rcpnt = zeros(num,2);
threshold = 0.2;
objsize = size(obj);
radr = ceil(objsize(1)/2);
radc = ceil(objsize(2)/2);

while(num<1000)
    [maxval, r, c] = max2d(imgR);
    if maxval < threshold
        break;
    end
    num = num+1;

    rcpnt(num,1) = r;
    rcpnt(num,2) = c;
    
    % Erase
    rs = r-radr;
    re = r+radr;
    cs = c-radc;
    ce = c+radc;
    imgR(rs:re, cs:ce) = 0;
end

rad = radr;
color = [255, 0, 0];    % Red
imgC = DrawCross(img, rcpnt, rad, color);
figure(5); imshow(imgC);

function [maxval, r, c] = max2d(img)
%

[row, col] = size(img);

img = img';
vec = img(:);

[maxval, ind] = max(vec);

r = floor((ind-1)/col);
c = (ind-1) - r*col;

r = r+1;
c = c+1;
end


function [imgC] = DrawCross(img, rcpnt, rad, color)
%
%

imgC = img;
[num, wid] = size(rcpnt);

for n = 1:num
    r = rcpnt(n,1);
    c = rcpnt(n,2);
    
    imgC(r-rad:r+rad, c, 1) = color(1);
    imgC(r, c-rad:c+rad, 1) = color(1);
    
    imgC(r-rad:r+rad, c, 2) = color(2);
    imgC(r, c-rad:c+rad, 2) = color(2);
    
    imgC(r-rad:r+rad, c, 3) = color(3);
    imgC(r, c-rad:c+rad, 3) = color(3);
end

end



