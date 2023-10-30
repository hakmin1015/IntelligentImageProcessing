% Lab01 : Point Operations
%

fname = 'lena.png';
img = imread(fname);

figure(1);
imshow(img);

imgR = img(:,:,1);
imgG = img(:,:,2);
imgB = img(:,:,3);

figure(2);
imshow([imgR, imgG, imgB]);

% Histogram
% figure(3);
% histogram(imgR, 256);
% figure(4);
% histogram(imgG, 256);
% figure(5);
hdata=histogram(imgB, 256);
histcnt = hdata.BinCounts;
figure(3);
stem(histcnt, 'k.');

% imImage Constrast
% imgY = a*imgX + b
a = 2; b = 0;
imgY = a*imgB + b;
figure(4);
imshow([imgB, imgY]);

% Histogram Stretching
imgX = double(imgB);
xmin = min(imgX(:));
xmax = max(imgX(:));   % max min editing -> optimal (L,R 5% point)
ymin = 0;
ymax = 255;
a = (ymax-ymin)/(xmax-xmin);
b = -a*xmin;
imgY = a*imgX+b;
figure(5);
imshow([imgX, imgY]/255);

% Histogram Equalization
imgEQ = histeq(imgB);
figure(6);
imshow([imgB, imgEQ]);

figure(7);
imhist(imgEQ);





