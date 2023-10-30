%Detecting rice frains

clear;
clc;

%Read an image
img = imread('rice1.png');

%color img -> gray img
if size(img, 3)==1
    gray = img;
else
    gray=rgb2gray(img);
end

figure(1);
imshow(gray);

% Display the histogram of the image
figure(2);
imhist(gray);
title('Histogram of Image (Gray)');

% Background subtraction
background = imopen(gray, strel('disk', 15));
gray_no_background = imsubtract(gray, background);

figure(3);
imshow(gray_no_background);

% Display the histogram of the image
figure(4);
imhist(gray_no_background);
title('Histogram of Image (No Background)');


%Thresholding
th=53;
imgB=gray_no_background >th; %get binary img

figure(5);
imshow(imgB);

%Binary filtering
se=strel('diamond',2);
imgB= imerode(imgB, se);
imgB= imdilate(imgB, se);

figure(6);
imshow(imgB);

stats = regionprops(imgB, {'Area','centroid'});
tab=struct2table(stats);

%Sorting
ordered = sortrows(tab,1,"descend");

%Show results
figure(7);
imshow(imgB);
hold on;
Num=97;
title([' Detected Rices : ', num2str(Num)]);

for n=1:Num
    r=ordered.Centroid(n,1);
    c=ordered.Centroid(n,2);
    text(r,c,num2str(n),'Color','red');
    %text(r,c,'+','color','red');
end

hold off;