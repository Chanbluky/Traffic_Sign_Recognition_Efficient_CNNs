function [T,area_ration,r,a,b]=certificate_circle(BW)
%************************************
%    ��������Ϊ�ж������Ƿ�ΪԲ��
%    BW��ֻ����һ������Ķ�ֵͼ��
%    ����ж���Բ�Σ��򷵻�ֵT=1�����򷵻�ֵΪT=0
%************************************
T=0;
se=strel('square',3);
erode_image=imerode(BW,se);
bound_image=BW-erode_image;
[y,x]=find(bound_image==1);
Npoint=sum(sum(BW));   %Npoint���������ص���Ŀ�����������
[r,a,b]=(nihe(x,y));%����ȡ����
r=round(r);
a=round(a);
b=round(b);
%ͨ�����������ص㣨������ж��Ƿ�ΪԲ��,ÿ�����ص�Ŀ�Ϊ��λ1
s_area=pi*r*r;
goal_area=Npoint;
area_ration=s_area/goal_area;
if area_ration>1
    area_ration=1/area_ration;
end
if area_ration>=0.2&&area_ration<=1.9%�ж�ΪԲ�ε�����
    T=1;
end
if Npoint<800
    T=0;    %����ͨ��־̫С�������ʶ��
end

