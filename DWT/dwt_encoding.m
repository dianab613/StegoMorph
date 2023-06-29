% %%%%%Encoding%%%%%%%%%%%%%%%%%

clear all
close all
clc
disp("Beginning encoding...")
coverImage=imread('.\models\15.jpg');
wname='haar';
msg='Hello World. This is a very secret message that should be kept hidden. Please respect the secrecy. Please respect the secrecy.';
data=[];
for i=1:length(msg)
d=msg(i);
data=[data d];
end
imshow(coverImage);
[LL,LH,HL,HH] = dwt2(coverImage,wname);
dec1 = [LL LH; 
HL HH 
];
figure
imshow(uint8(dec1));
LH = rescale(LH, min(LH(:)), max(LH(:)));
HL = rescale(HL, min(HL(:)), max(HL(:)));
HH = rescale(HH, min(HH(:)), max(HH(:)));
M=max(data);
data_norm=data/M;
n=length(data);
[x y]=size(LH);
LH(1,1)=-1*n/10;
LH(1,2)=-1*M/10;
for i=1:ceil(n/2)
HL(i,y)=data_norm(i);
end
for i=ceil(n/2)+1:1:n
HH(i,y)=data_norm(i);
end
stegoImage=idwt2(LL,LH,HL,HH,wname);
figure
imshow(uint8(stegoImage));
[x y]=size(LL);
imshow(uint8(stegoImage));

imwrite(uint8(stegoImage),'.\stego_images\secret_m1.jpg','jpg');

LHSize = numel(LH);
maxBytes = floor(LHSize / 8)

stegoImage = imread('.\stego_images\secret_m1.jpg');

mse = immse(coverImage, stegoImage)

peaksnr = psnr(coverImage, stegoImage)

ssimval = ssim(coverImage, stegoImage)

disp("Encoding finalized.")
return




