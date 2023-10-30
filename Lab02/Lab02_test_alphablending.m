% Test_ alpha blending

clear;
clc;

imgA = imread("baboon.png");
imgB = imread("lena.png");

alp = 0:0.1:1;
for i=1:length(alp)
    ap = alp(i);
    img = (1-ap)*imgA + ap*imgB;
    figure(i);
    imshow(img);
    pause(1);
end