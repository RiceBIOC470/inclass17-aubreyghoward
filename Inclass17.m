%GB comments
1. 75. Close! Please find my notes below to fix your problem. 
2. 100 
Overall 88
Notes: 
diffs= zeros(200,200);
for  ov1= 1:400;
    for ov2= 1:400;
        pix1=img1((end-ov1):end,(end-ov2):end);
        pix2=img2(1:(1+ov1),1:(1+ov2));
        diffs(ov1,ov2)=sum(sum(abs(pix1-pix2)))/(ov1*ov2);
    end
end
figure; plot(diffs);
minMatrix = min(diffs(:));
[ovX, ovY]=find(diffs==minMatrix);
ovX = 199;
ovY=199;
img2_align = [zeros(800, size(img2,2)-ovY+1),img2];
img2_align=[zeros(size(img2,1)-ovX+1,size(img2_align,2)); img2_align];
imshowpair(img1,img2_align);


%In this folder, you will find two images img1.tif and img2.tif that have
%some overlap. Use two different methods to align them - the first based on
%pixel values in the original images and the second using the fourier
%transform of the images. In both cases, display your results. 


clear all;
q = 0;
disp('start')


img1 = imread('img1.tif');
img2 = imread('img2.tif');

img1_edit = img1(401:end,401:end);
img2_edit = img2(1:400,1:400);

%Checking the orientation to see how the images might overlap
q = q+1;figure(q);
subplot(1,2,1);imshow(img1_edit,[]);
subplot(1,2,2);imshow(img2_edit,[]);


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

%None of these images seem to do the trick... The overlap must be on the
%corner.


%Check and perform overlapping at the corner
img1fft = fft2(img1_edit); img2fft = fft2(img2_edit);
[nr,nc] = size(img2fft);
CC = ifft2(img1fft.*conj(img2fft));
CCabs = abs(CC);
q = q+1;figure(q); imshow(CCabs,[]);

[row_shift, col_shift] = find(CCabs == max(CCabs(:)))
Nr = ifftshift(-fix(nr/2):ceil(nr/2)-1);
Nc = ifftshift(-fix(nc/2):ceil(nc/2)-1);

row_shift = Nr(row_shift)
col_shift = Nc(col_shift)

%The purpose of the multiple of three is to accoun for the diminished size
%of the edited images. Beacuse each image was reduced by half the size, the
%row/column shifts need to be multiplied by two, plus the shift to account
%for the adjustment in overlap size. 
img_shift = zeros(size(img2)+[-row_shift*3,-col_shift*3]);
img_shift((end-799):end,(end-799):end) = img2;

q = q+1;figure(q); imshowpair(img1,img_shift);



