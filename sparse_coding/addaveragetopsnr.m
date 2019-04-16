%%首先计算一下b和DZ之间的平均值差多少，然后每个像素点加上这个差值，然后再计算psnr值。
close all;
clc,clear;
%addpath('./image_helpers');
load ./filters_ours_obj1.27e+04.mat Dz;
load ./data_b.mat b;
size(Dz)
Dz=Dz(1+5:110-5,1+5:110-5,:);
size(Dz)
size(b)
for i=1:size(b,3)
    %对每一个Dz进行亮度的补偿
    
    %p=psnr(b(:,:,i),Dz(:,:,i));
    p=ssim(b(:,:,i),Dz(:,:,i));
    subplot(121),imshow(b(:,:,i)),title(sprintf('ori num:%d',i));
    subplot(122),imshow(Dz(:,:,i)),title(sprintf('PSNR:%5.5g',p));
    pause(0.5);
end
m=size(b,1);
n=size(b,2);
s_b=0;
s_Dz=0;
for i=1:m
    for j=1:n
        s_b=s_b+b(i,j,1);
        s_Dz=s_Dz+Dz(i,j,1);
    end
end

del=(s_b-s_Dz)/(100*100);
Dz1=zeros(100,100,1);
for i=1:m
    for j=1:n
        Dz1(i,j,1)=Dz(i,j,1)+del;
    end
end
% p=psnr(b(:,:,1),Dz1(:,:,1));
% p1=psnr(b(:,:,1),Dz(:,:,1));
p=ssim(b(:,:,1),Dz1(:,:,1));
p1=ssim(b(:,:,1),Dz(:,:,1));
s1=b(:,:,1);
s1=sum(s1(:));
s2=Dz(:,:,1);
s2=sum(s2(:));  
s3=Dz1(:,:,1);
s3=sum(s3(:));
subplot(131),imshow(b(:,:,1)),title(sprintf('sum:%5.5g',s1));
subplot(132),imshow(Dz(:,:,1)),title(sprintf('sum:%5.5g  PSNR:%5.5g',s2,p1));
subplot(133),imshow(Dz1(:,:,1)),title(sprintf('sum:%5.5g  PSNR:%5.5g',s3,p));
%看来psnr值和亮度没啥关系。
