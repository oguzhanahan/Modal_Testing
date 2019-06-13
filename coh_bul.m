clear 
clc
freqmax=3200; %Nyquist Frekans�, Hz
N=6400; % �rnekleme Zaman�, Hz
point=7; %�eki� testindeki pivot noktas�
df=freqmax/N; %��z�n�rl�k
freqn=df; 
files = dir('coh_*.uff'); %frf_ ile ba�layan b�t�n dosyalar okunmaktad�r. 
nfiles = length(files); %Ka� adet dosya oldu�u belirlenmi�tir. Do�ru say�da dosyan�n okundu�unu ��renmek ama�l�d�r.
operet=[1,2,3,4,5,6,7,8,9,10,11,12,13]; %files struct'�nda toparlanm�� verilerin i�lenme s�ras�
%% Veriler okunur. 
for J=1:length(operet)
    I=operet(J);
    infile = files(I).name;  %hangi verinin okundu�u yaz� format�nda tan�mlan�r
    infile
    file_A=fopen(infile,'r'); %okunacak verinin ismi tan�mlan�r. 'r' hali haz�rda tan�mlanan verinin okunmas�d�r.
for i=1:13
    unnecesseryA=fgetl(file_A); %Verinin okunmas�ndaki gereksiz, uff hakk�nda bilgi veren sat�rlar silinir.
end

freq=freqn:freqn:freqmax; %al�nm�� olan fourier analizinin frekanslar� elde edilir.
freqr=2*pi*freq; % Hz birimi rad/s'ye �evirilir
w_2=(freqr.^2).'; %�nertanstan reseptansa ge�i� i�in frekanslar�n karesi al�n�r.

data_A=fscanf(file_A,'%g',N); % okunmu� olan frekans cevap fonksiyonun reel ve imajiner k�s�mlar� ayn� veride okunur. 


cohA(:,J)=data_A; %reseptans verisi kompleks d�zlemde elde edilir.
end
    s={'kontrol';'12nci dk';'26nci dk';'36nci dk';'47nci dk';'59nci dk';
    '67nci dk';'80nci dk';'91nci dk';'98nci dk';'107nci dk';'123nci dk';'135nci dk'};
plot(freq,cohA,'LineWidth',2)
set(gca,'Xlim',[0,3200],'YLim',[0 1])
format_ayar('PMMA Deneyinde','Koherans')
legend(s)
