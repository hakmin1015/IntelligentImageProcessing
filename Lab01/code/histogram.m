fname = 'lena.png';
img = imread(fname);

imgR = img(:,:,1);
imgG = img(:,:,2);
imgB = img(:,:,3);

hdata=histogram(imgB, 256);
histcnt = hdata.BinCounts;
figure(1);
stem(histcnt, 'k.');
