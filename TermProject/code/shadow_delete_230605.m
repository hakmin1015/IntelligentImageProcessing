fname = "obj_image2.jpg";
objImage2 = imread(fname);

figure(10); imshow(objImage2);

objImage2 = rgb2gray(objImage2);
objImage2 = histeq(objImage2);
figure(30); imshow(objImage2);
figure(40); imhist(objImage2);

objImage2 = double(objImage2);
obj2 = objImage2(40:1800+40,80:300+65);
figure(20); imshow(obj2);

patt = flipud(fliplr(obj2));
patt = patt/sum(patt(:));
patt = patt - mean(patt(:));

convImage = conv2(PerspectiveImage, patt, 'same');
convImage = convImage/max(convImage(:));

figure(3); imshow(convImage);