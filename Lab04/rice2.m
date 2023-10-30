%Detecting rice frains

clear;
clc;

%Read an image
img = imread('rice2.png');
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

% lowpassfiltering
gray = imgaussfilt(gray, 1);

%edge detact
imgB=edge(gray);

% 결과 출력
figure(3);
imshow(imgB);

%영역 추출 및 Sorting
se=strel('diamond',3);
%imgB= imerode(imgB, se);
imgB= imdilate(imgB, se);

stats = regionprops(imgB, {'Area','centroid'});
tab=struct2table(stats);

ordered = sortrows(tab,1,"descend");

%Show results
figure(4);
imshow(imgB);
hold on;
Num=14;
title([' Detected Rices : ', num2str(Num)]);

for n=1:Num
    r=ordered.Centroid(n,1);
    c=ordered.Centroid(n,2);
    text(r,c,num2str(n),'Color','red');
    %text(r,c,'+','color','red');
end

hold off;