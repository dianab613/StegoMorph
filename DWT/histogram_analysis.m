clear all
close all
clc

stegoimage = imread('.\stego_images\secret_o5.jpg');
grayImageS = rgb2gray(stegoimage);
[countS, binLocationS] = imhist(grayImageS);
figure;
bar(binLocationS, countS);
title('Histogram of StegoImage');
xlabel('Pixel Intensity');
ylabel('Frequency');
imageMean = mean(grayImageS(:));
imageMedian = median(grayImageS(:));
imageVariance = var(double(grayImageS(:)));
imageSkewness = skewness(double(grayImageS(:)));
fprintf('Mean: %.4f \n Median: %.4f \n Variance: %.4f \n Skewness: %.4f \n', imageMean, imageMedian, imageVariance, imageSkewness);

fprintf('\n')

coverImage = imread('.\celeba\test\female\000381.jpg');
grayImageC = rgb2gray(coverImage);
[countC, binLocationC] = imhist(grayImageC);
figure;
bar(binLocationC, countC);
title('Histogram of CoverImage');
xlabel('Pixel Intensity');
ylabel('Frequency');
imageMean1 = mean(grayImageC(:));
imageMedian1 = median(grayImageC(:));
imageVariance1 = var(double(grayImageC(:)));
imageSkewness1 = skewness(double(grayImageC(:)));
fprintf('Mean: %.4f \n Median: %.4f \n Variance: %.4f \n Skewness: %.4f \n', imageMean1, imageMedian1, imageVariance1, imageSkewness1);