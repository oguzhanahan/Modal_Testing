clear 
clc
freqmax=3200; %Nyquist Frekansý, Hz
N=6400; % Örnekleme Zamaný, Hz
point=7; %çekiç testindeki pivot noktasý
df=freqmax/N; %Çözünürlük
freqn=df; 
files = dir('coh_*.uff'); %frf_ ile baþlayan bütün dosyalar okunmaktadýr. 
nfiles = length(files); %Kaç adet dosya olduðu belirlenmiþtir. Doðru sayýda dosyanýn okunduðunu öðrenmek amaçlýdýr.
operet=[1,2,3,4,5,6,7,8,9,10,11,12,13]; %files struct'ýnda toparlanmýþ verilerin iþlenme sýrasý
%% Veriler okunur. 
for J=1:length(operet)
    I=operet(J);
    infile = files(I).name;  %hangi verinin okunduðu yazý formatýnda tanýmlanýr
    infile
    file_A=fopen(infile,'r'); %okunacak verinin ismi tanýmlanýr. 'r' hali hazýrda tanýmlanan verinin okunmasýdýr.
for i=1:13
    unnecesseryA=fgetl(file_A); %Verinin okunmasýndaki gereksiz, uff hakkýnda bilgi veren satýrlar silinir.
end

freq=freqn:freqn:freqmax; %alýnmýþ olan fourier analizinin frekanslarý elde edilir.
freqr=2*pi*freq; % Hz birimi rad/s'ye çevirilir
w_2=(freqr.^2).'; %Ýnertanstan reseptansa geçiþ için frekanslarýn karesi alýnýr.

data_A=fscanf(file_A,'%g',N); % okunmuþ olan frekans cevap fonksiyonun reel ve imajiner kýsýmlarý ayný veride okunur. 


cohA(:,J)=data_A; %reseptans verisi kompleks düzlemde elde edilir.
end
    s={'kontrol';'12nci dk';'26nci dk';'36nci dk';'47nci dk';'59nci dk';
    '67nci dk';'80nci dk';'91nci dk';'98nci dk';'107nci dk';'123nci dk';'135nci dk'};
plot(freq,cohA,'LineWidth',2)
set(gca,'Xlim',[0,3200],'YLim',[0 1])
format_ayar('PMMA Deneyinde','Koherans')
legend(s)
