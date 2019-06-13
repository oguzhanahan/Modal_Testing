clear 
clc
T=2; %Nyquist Frekansý, Hz
fs=2.56*3200; % Örnekleme Zamaný, Hz
point=7; %çekiç testindeki pivot noktasý
dt=1/fs; %Çözünürlük
tn=dt; 
files = dir('time_*.uff'); %frf_ ile baþlayan bütün dosyalar okunmaktadýr. 
nfiles = length(files); %Kaç adet dosya olduðu belirlenmiþtir. Doðru sayýda dosyanýn okunduðunu öðrenmek amaçlýdýr.
operet=[2 4 5]; %files struct'ýnda toparlanmýþ verilerin iþlenme sýrasý
%% Veriler okunur. 
for J=1:length(operet)
    I=operet(J);
    infile = files(I).name;  %hangi verinin okunduðu yazý formatýnda tanýmlanýr
    infile
    file_A=fopen(infile,'r'); %okunacak verinin ismi tanýmlanýr. 'r' hali hazýrda tanýmlanan verinin okunmasýdýr.
for i=1:13
    unnecesseryA=fgetl(file_A); %Verinin okunmasýndaki gereksiz, uff hakkýnda bilgi veren satýrlar silinir.
end

time=tn:tn:T; %alýnmýþ olan fourier analizinin frekanslarý elde edilir.


data_A=fscanf(file_A,'%g',2*fs); % okunmuþ olan frekans cevap fonksiyonun reel ve imajiner kýsýmlarý ayný veride okunur. 


timeA(:,J)=data_A; %zaman verisi
end
    s={'1. ölçüm';'2. ölçüm';'3. Ölçüm';};
plot(time,timeA,'LineWidth',2)
set(gca,'Xlim',[0,0.1],'YLim',[-300 300])
set(gca,'FontSize',14)
set(gca,'FontName','NewTimesRoman')
A3 = 'Ývme-Zaman Grafiði';
A2='Ölçülen';
A1 = 'Tekrarlanabirlik Testinde'; 
formatSpec = '%1$s %2$s %3$s';
strtt = sprintf(formatSpec,A1,A2,A3);
title(strtt,'FontSize',14,'FontName','TimesNewRoman')
xlabel('zaman (s)','FontSize',14,'FontName','TimesNewRoman')
ylabel('ivme','FontSize',14,'FontName','TimesNewRoman')
grid
legend(s)
