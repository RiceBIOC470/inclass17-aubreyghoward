%In this folder, you will find two images img1.tif and img2.tif that have
%some overlap. Use two different methods to align them - the first based on
%pixel values in the original images and the second using the fourier
%transform of the images. In both cases, display your results. 
clear all;
q = 0;
disp('start')


img1 = imread('img1.tif');
img2 = imread('img2.tif');
%Checking the orientation to see how the images might overlap
q = q+1;figure(q);
subplot(1,2,1);imshow(img1,[]);
subplot(1,2,2);imshow(img2,[]);


%Checking overlap along each of the image edges. 
corr = zeros(1,500);
for ov = 1:length(img1)-1
    pix1 = img1(:,(end-ov):end);
    pix2 = img2(:,1:(1+ov));
    corr(ov) = mean2((pix1-mean2(pix1)).*(pix2-mean2(pix2)));
end
q = q+1;figure(q);plot(corr);
xlabel('Overlap','FontSize',28);ylabel('Mean difference');

corr = zeros(1,500);
for ov = 1:length(img1)-1
    pix1 = img1((end-ov):end,:);
    pix2 = img2(1:(1+ov),:);
    corr(ov) = mean2((pix1-mean2(pix1)).*(pix2-mean2(pix2)));
end
q = q+1;figure(q);plot(corr);
xlabel('Overlap','FontSize',28);ylabel('Mean difference');

corr = zeros(1,400);
for ov = 1:length(img1)-1
    pix1 = img1(:,(end-ov):end);
    pix2 = img2(1:(1+ov),:);
    corr(ov) = mean2((pix1-mean2(pix1)).*(pix2'-mean2(pix2')));
end
q = q+1;figure(q);plot(corr);
xlabel('Overlap','FontSize',28);ylabel('Mean difference');

corr = zeros(1,400);
for ov = 1:(length(img1)/2)
    pix1 = img1((end-ov):end,:);
    pix2 = img2(:,1:(1+ov));
    corr(ov) = mean2((pix1-mean2(pix1)).*(pix2'-mean2(pix2')));
end
q = q+1;figure(q);plot(corr);
xlabel('Overlap','FontSize',28);ylabel('Mean difference');

%None of these images seem to do the trick...


%Check and perform overlapping at the corner
img1fft = fft2(img1); img2fft = fft2(img2);
[nr,nc] = size(img2fft);
CC = ifft2(img1fft.*conj(img2fft));
CCabs = abs(CC);
q = q+1;figure(q); imshow(CCabs,[]);

[row_shift, col_shift] = find(CCabs == max(CCabs(:)));
Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);

row_shift = Nr(row_shift);
col_shift = Nc(col_shift);

img_shift = zeros(size(img2)+[row_shift,col_shift]);
img_shift((end-799):end,(end-799:end)) = img2;

figure; imshowpair(img1,img_shift);

%%

