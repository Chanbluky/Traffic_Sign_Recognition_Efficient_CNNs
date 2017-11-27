%% This is just a toy code to explain how the localization refinement alogrithem works.
% reference books and sources: Nixon, Mark S., and Alberto S. Aguado. Feature extraction & image processing %for computer vision. Academic Press, 2012.

% Load an example
clc
clear
close all
N=111
strr=num2str(N);
strr=[strr '.jpg'];
rgb_image=imread(strr);
for i=1:3
    temp(:,:,i) =imresize(rgb_image(:,:,i),[250,250],'bilinear');
end
 rgb_image=temp;
figure(1)
imshow(rgb_image);
title('ԭ�ɼ�ͼ��');
double_rgb=double(rgb_image);
%%
%���ڹ�һ��RGB��ɫ�ռ�R�����ķָһ���̶��Ͽ���ȥ������Ӱ��
sum_rgb=double_rgb(:,:,1)+double_rgb(:,:,2)+double_rgb(:,:,3);
r_image=double_rgb(:,:,1)./sum_rgb;
g_image=double_rgb(:,:,2)./sum_rgb;
b_image=double_rgb(:,:,3)./sum_rgb;
rbgn=cat(3,r_image,g_image,b_image);
figure(2)
imshow(rbgn);
title('��һ�����RGBͼ��');
%%
%���ں�ɫ��ɫ���ж���ָ�,ʹ�������еķ�������ǿ��ɫ����
%BW=max(0,min(r_image-b_image,r_image-g_image)); % ��ɫ������ǿ
%BW=max(0,min(b_image-r_image,b_image-g_image));  % ��ɫ������ǿ
BW=max(0,min(r_image-b_image,g_image-b_image));  % ��ɫ������ǿ
figure(12)
imshow(BW)
%%
%ʹ�������෽�����򷨣���R����������ֵ�ָ�
thresh=graythresh(BW);
BW=im2bw(BW,thresh);
figure(3)
imshow(BW);
title('��ֵ�ָ��ͼ��');
%%
%������̬ѧ�Ĵ���ȥ��ë�̵����������ҿ��Լ���С�������ͨ������Ŀ
%Ҫ���������Ƭ�н�ͨ��־��ռ�����������̫С������ָ����
BW=imopen(BW,ones(3,3));  %����������飬ʹ�ñ���������ʣ�ȷ���ṹԪ�صĳߴ�Ϊ3*3
figure(4)
imshow(BW);
title('��̬ѧ�����㴦���ͼ��');
 %%
%������ȡ���������
BW=imfill(BW,'holes');  %�������
figure(5)
imshow(BW);      %BW����������
title('���֮��');

se=strel('square',3);
erode_image=imerode(BW,se);
bound_image=BW-erode_image;
figure(6)
imshow(bound_image);   %bound_image�Ǳ߽�����
title('�߽���ȡ���ͼ��');
%��ͨ���򣨶���һ�����ص�߽��γɵ�����
[L,NUM]=bwlabel(BW,8);
disp(['ͼ�й���' num2str(NUM) '����ͨ����'])
%%
%���ж������ֻ�����������ǰ3������
switch NUM
    case 0
        errordlg(' û�м�⵽���ܵ�Բ�ν��ͨ��־');
        %break;
    case 1
        leave_BW{1}=L;
         [t(1),area_ration(1),r(1),a(1),b(1)]= certificate_circle(leave_BW{1});  %Բ�μ��
        figure
        imshow(leave_BW{1}),title('���ܵĽ�ͨ��־����');  
        %break;
    case 2
        leave_BW{1}=(L==1);
        leave_BW{2}=(L==2);
        f_l=figure('name','�ָ�õ���2����Ҫ����');
        subplot(1,2,1),imshow(leave_BW{1});
        subplot(1,2,2),imshow(leave_BW{2});
        [t(1),area_ration(1),r(1),a(1),b(1)]= certificate_circle(leave_BW{1});   %Բ�μ��
        [t(2),area_ration(2),r(2),a(2),b(2)]= certificate_circle(leave_BW{2});
        %break;
    otherwise
        for k=1:NUM
            [y,x]=find(L==k);  %���Ϊk����ͨ��������꣬��һ��Ԫ����yֵ���ڶ���Ԫ����xֵ
            area(k)=length(x); %���Ϊk����������ֵ�������
        end
        [maxunm,maxindex]=sort(area,'descend'); %index�������3����������
        max_area_index=maxindex(1:3);
        leave_BW{1}=(L==max_area_index(1));
        leave_BW{2}=(L==max_area_index(2));
        leave_BW{3}=(L==max_area_index(3));
        f_l=figure('name','�ָ�õ���3����Ҫ����');
        subplot(1,3,1),imshow(leave_BW{1});
        subplot(1,3,2),imshow(leave_BW{2});
        subplot(1,3,3),imshow(leave_BW{3});
        [t(1),area_ration(1),r(1),a(1),b(1)]= certificate_circle(leave_BW{1});    %Բ�μ��
        [t(2),area_ration(2),r(2),a(2),b(2)]= certificate_circle(leave_BW{2});
        [t(3),area_ration(3),r(3),a(3),b(3)]= certificate_circle(leave_BW{3}); 
end
%%
%����ͨ��׼�ָ����
save_picture_num=1;
disp([t,'***********'])
for k=1:length(t)
    if t(k)==1
       %%
        %�ָ����ͨ��־ʱ��Ҫ����һ���հף���֤��־��������
        row_1=b(k)-r(k)*1.1;
        row_2=b(k)+r(k)*1.1;
        col_1=a(k)-r(k)*1.1;
        col_2=a(k)+r(k)*1.1;
        row_1=round(row_1);
        row_2=round(row_2);
        col_2=round(col_2);
        col_1=round(col_1);
%         %%
        %����޳���ͨ��־��Χ���еı�������ʹ����δ���
        for i=1:3
        logical_BW=leave_BW{k};
        temp=rgb_image(:,:,i);
        temp(find(logical_BW==0))=0;
        rgb_image(:,:,i)=temp;
        end
        %%
        fenge_image=rgb_image(row_1:row_2,col_1:col_2,:);   
        figure,imshow(fenge_image)
        title('�ָ���ȡ���Ľ�ͨ��־')
        fenge_gray=rgb2gray(fenge_image);
        fenge_image=imresize(fenge_image,[80,80],'bilinear');  %��񻯷ָ�ͼ��ĳߴ�
        figure,imshow(fenge_image)
        title('�ָ�õ��Ĺ̶��ߴ罻ͨ��־');
        str=num2str(save_picture_num);
        save_picture_num=save_picture_num+1;
%         str=strcat('result_',num2str(N),'_',str,'.bmp'); %����ͼƬ
%         imwrite(fenge_image,str);
    end
end
ll=33

    


