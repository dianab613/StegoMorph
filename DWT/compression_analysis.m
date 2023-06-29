clear all
close all
clc

stegoimage = imread('.\stego_images\secret_m4.jpg');
figure
imshow(stegoimage);
imwrite(stegoimage, 'compressed_stegoimage.jpg', 'jpg', 'Quality', 90);
compressed_stegoimage = imread('compressed_stegoimage.jpg');
psnr_value = psnr(stegoimage, compressed_stegoimage);
fprintf('PSNR value: %.2f dB\n', psnr_value);
