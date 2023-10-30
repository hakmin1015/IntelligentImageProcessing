clear;
clc;

fname = "Test_cir03.jpg";
img = imread(fname);
figure(1); imshow(img);

imgY = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;
imgY = double(imgY);
obj = imgY(15:15+21,112:112+21);
figure(2); imshow(obj);

patt = flipud(fliplr(obj));
patt = patt/sum(patt(:));
patt = patt - mean(patt(:));

imgR = conv2(imgY, patt, 'same');
imgR = imgR/max(imgR(:));

figure(3); imshow(imgR);
figure(4); mesh(imgR);

num = 0;
rcpnt = zeros(num,2);
threshold = 0.6;
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
    rs = max(r-radr, 1);
    re = min(r+radr, size(imgR, 1));
    cs = max(c-radc, 1);
    ce = min(c+radc, size(imgR, 2));
    imgR(rs:re, cs:ce) = 0;
end

rad = radr;
color = [255, 0, 0];    % Red
imgC = DrawCross(img, rcpnt, rad, color);
figure(5); imshow(imgC);

function [maxval, r, c] = max2d(img)
[row, col] = size(img);
vec = img(:);

[maxval, ind] = max(vec);

r = mod(ind-1, row)+1;
c = floor((ind-1)/row)+1;
end

function [imgC] = DrawCross(img, rcpnt, rad, color)
imgC = img;
[num, ~] = size(rcpnt);

for n = 1:num
    r = rcpnt(n,1);
    c = rcpnt(n,2);
    
    imgC(max(r-rad,1):min(r+rad,end), c, 1) = color(1);
    imgC(r, max(c-rad,1):min(c+rad,end), 1) = color(1);
    
    imgC(max(r-rad,1):min(r+rad,end), c, 2) = color(2);
    imgC(r, max(c-rad,1):min(c+rad,end), 2) = color(2);
    
    imgC(max(r-rad,1):min(r+rad,end), c, 3) = color(3);
    imgC(r, max(c-rad,1):min(c+rad,end), 3) = color(3);
end

end