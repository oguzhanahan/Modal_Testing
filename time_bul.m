clear 
clc
T=2; %Nyquist Frekans�, Hz
fs=2.56*3200; % �rnekleme Zaman�, Hz
point=7; %�eki� testindeki pivot noktas�
dt=1/fs; %��z�n�rl�k
tn=dt; 
files = dir('time_*.uff'); %frf_ ile ba�layan b�t�n dosyalar okunmaktad�r. 
nfiles = length(files); %Ka� adet dosya oldu�u belirlenmi�tir. Do�ru say�da dosyan�n okundu�unu ��renmek ama�l�d�r.
operet=[2 4 5]; %files struct'�nda toparlanm�� verilerin i�lenme s�ras�
%% Veriler okunur. 
for J=1:length(operet)
    I=operet(J);
    infile = files(I).name;  %hangi verinin okundu�u yaz� format�nda tan�mlan�r
    infile
    file_A=fopen(infile,'r'); %okunacak verinin ismi tan�mlan�r. 'r' hali haz�rda tan�mlanan verinin okunmas�d�r.
for i=1:13
    unnecesseryA=fgetl(file_A); %Verinin okunmas�ndaki gereksiz, uff hakk�nda bilgi veren sat�rlar silinir.
end

time=tn:tn:T; %al�nm�� olan fourier analizinin frekanslar� elde edilir.


data_A=fscanf(file_A,'%g',2*fs); % okunmu� olan frekans cevap fonksiyonun reel ve imajiner k�s�mlar� ayn� veride okunur. 


timeA(:,J)=data_A; %zaman verisi
end
    s={'1. �l��m';'2. �l��m';'3. �l��m';};
plot(time,timeA,'LineWidth',2)
set(gca,'Xlim',[0,0.1],'YLim',[-300 300])
set(gca,'FontSize',14)
set(gca,'FontName','NewTimesRoman')
A3 = '�vme-Zaman Grafi�i';
A2='�l��len';
A1 = 'Tekrarlanabirlik Testinde'; 
formatSpec = '%1$s %2$s %3$s';
strtt = sprintf(formatSpec,A1,A2,A3);
title(strtt,'FontSize',14,'FontName','TimesNewRoman')
xlabel('zaman (s)','FontSize',14,'FontName','TimesNewRoman')
ylabel('ivme','FontSize',14,'FontName','TimesNewRoman')
grid
legend(s)
