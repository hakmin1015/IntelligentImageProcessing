% 원본 이미지 로드
originalImage = imread('11111111.jpg');
originalImage = imrotate(originalImage, -90);
figure(1); imshow(originalImage);

% 4개의 점 선택
% pts = ginput(4); % 사용자가 4개의 점을 찍도록 합니다.

% 주어진 4개의 점 좌표
% pts1 = pts;
pts1 = [1020, 1570; 1840, 1600; 2130, 3170; 750, 3120]; % 원본 좌표
pts2 = [1, 1; 3024, 1; 3024, 4032; 1, 4032]; % 변환 좌표

% 이미지에 좌표 표시
figure(1);
hold on;
plot(pts1(:, 1), pts1(:, 2), 'r+', 'MarkerSize', 10);
hold off;

% 원근 변환 행렬 계산
H_perspective = fitgeotrans(pts1, pts2, 'projective');

% 이미지 변환
outputImageSize = [4032, 3024];
outputImage = imwarp(originalImage, H_perspective, 'OutputView', imref2d(outputImageSize));

outputImage = histeq(outputImage);

% 변환된 이미지 출력
figure(2); imshow(outputImage);

objImage = imread('1_8.png');
obj = imresize(objImage, [1050, 1500]);
obj = histeq(obj);
figure(3); imshow(obj);

% 객체 이미지로 사용할 블록 크기
blockSize = size(obj);

% 이미지의 크기 및 블록 수 계산
imageSize = size(outputImage);
numBlocks = floor([imageSize(1) / blockSize(1), imageSize(2) / blockSize(2)]);

% 블록 인식 및 개수 세기
numOccurrences = 0;

for i = 1:numBlocks(1)
    for j = 1:numBlocks(2)
        % 현재 블록 추출
        startIndex = (i - 1) .* blockSize(1) + 1;
        endIndex = startIndex + blockSize(1) - 1;
        startColIndex = (j - 1) .* blockSize(2) + 1;
        endColIndex = startColIndex + blockSize(2) - 1;
        block = outputImage(startIndex:endIndex, startColIndex:endColIndex, :);

        % 템플릿 매칭 수행
        similarity = normxcorr2(obj(:,:,1), block(:,:,1)); % 빨간 채널만 사용

        % 매칭 결과를 기반으로 블록 인식
        threshold = 0.24;  % 임계값 설정
        [maxValue, ~] = max(similarity(:));
        if maxValue > threshold
            numOccurrences = numOccurrences + 1;

            % 같은 패턴의 블록을 빨간색 "+"로 표시
            centerX = (startColIndex + endColIndex) / 2;
            centerY = (startIndex + endIndex) / 2;
            figure(2);
            hold on;
            plot(centerX, centerY, 'r+', 'MarkerSize', 10);
            hold off;
        end
    end
end

% 결과 출력
disp(['STOP 블록 개수: ', num2str(numOccurrences)]);
