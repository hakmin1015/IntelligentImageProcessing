% Lab01 : Point Operations

fname = 'lena.png';
img = imread(fname);

imgR = img(:,:,1);
imgG = img(:,:,2);
imgB = img(:,:,3);


% Histogram Stretching
imgX_R = double(imgR);
imgX_G = double(imgG);
imgX_B = double(imgB);

[hdata_R, ~] = histcounts(imgX_R(:), 256);
cumhist_R = cumsum(hdata_R) / numel(imgX_R);
[hdata_G, ~] = histcounts(imgX_G(:), 256);
cumhist_G = cumsum(hdata_G) / numel(imgX_G);
[hdata_B, ~] = histcounts(imgX_B(:), 256);
cumhist_B = cumsum(hdata_B) / numel(imgX_B);

xmin = find(cumhist_R > 0.20, 1, 'first');
xmax = find(cumhist_R >= 0.80, 1, 'first') - 1;

ymin = 0;
ymax = 255;
a = (ymax - ymin) / (xmax - xmin);
b = -a * xmin;
imgY_R = a * imgX_R + b;
imgY_G = a * imgX_G + b;
imgY_B = a * imgX_B + b;

figure(1);
imshow([imgX_R, imgY_R] / 255);
figure(2);
imshow([imgX_G, imgY_G] / 255);
figure(3);
imshow([imgX_B, imgY_B] / 255);