clc
clear
load('frf.mat')
[U S V]=svd(frf_top); 
%  U sol singular de�erler
%  S singular Matrix
%  V sa� singular de�erler
aU=findpeaks(20.*log10(U(:,1)),'THRESHOLD',0.03,'MINPEAKDISTANCE',30);
sayU=20.*log10(U(:,1));
alfa=frf_real+frf_img;
for I=1:length(aU)
b(I)=find(sayU==aU(I));
wr(I)=w(b(I));
end
for i=1:3
    if wr(i)<16.25
        wn(i)=wr(i);
    elseif wr(i)>=16.25
        wn(i)=wr(i+1);
    end
end
wr=wr';
nu=[0.002 0.001 0.00034];
%%%%r�dvan, G�rkan'�n dedi�i gibi �ok g�zel �ekiyor frekanslar�,
%%%%do�al frekanslar� �uraya yazd�ktan sonra interpolasyon yapaca��z
%%%%Oradan, n�leri �ekeriz.