% 이미지 엣지 불러오기
imgB = imread('11111111.jpg');
imgB = rgb2gray(imgB);
imgB = edge(imgB, 'canny');

% regionprops를 사용하여 특징 추출
stats = regionprops(imgB, {'Area', 'Centroid'});
tab = struct2table(stats);

% Sorting
ordered = sortrows(tab, 1, "descend");

% Area가 100 이하인 엣지 제거
idx = ordered.Area <= 10;
ordered(idx, :) = [];
numEdges = size(ordered, 1);

% imgB에 엣지 제거 반영
imgB = false(size(imgB));
for i = 1:numEdges
    centroid = round(ordered.Centroid(i, :));
    imgB(centroid(2), centroid(1)) = 1;
end

% imgB에 엣지 표시
figure;
imshow(imgB);
title('Processed Image with Removed Edges');
