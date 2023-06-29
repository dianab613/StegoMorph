%%%%%Decoding%%%%%%%%%%%%%%%%%

disp("Beginning decoding")

im=imread('.\stego_images\secret_m1.jpg');
[LL,LH,HL,HH] = dwt2(stegoImage,wname);
data=[];
data_norm=[];
n=ceil(abs(LH(1,1)*10));
M=ceil(abs(LH(1,2)*10));
for(i=1:1:ceil(n/2))
data_norm(i)=HL(i,y);
end
for(i=ceil(n/2)+1:1:n)
data_norm(i)=HH(i,y);
end
data=ceil(data_norm*M)-1;
rec_msg='';
for(i=1:length(data))
rec_msg=strcat(rec_msg,data(i));
end
rec_msg