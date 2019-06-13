%% Modal analiz Programý
%Yazan: A.Oðuzhan Ahan
%Bu Program, .uff uzantýlý olarak elde edilen frekans cevap fonksiyonlarýný 
%okuyarak iþler. Her bir parametrenin yanlarýna anlamlarý iliþtirilmiþ.
%bu þekilde takip etmesi daha kolay bir kod elde edilmesi amaçlanmýþtýr.
%% Ölçüm koþullarý Tanýmlanýr. 
clear 
clc
freqmax=3200; %Nyquist Frekansý, Hz
N=6400; % Örnekleme Zamaný, Hz
point=7; %çekiç testindeki pivot noktasý
df=freqmax/N; %Çözünürlük
freqn=df; 
files = dir('frf_*.uff'); %frf_ ile baþlayan bütün dosyalar okunmaktadýr. 
nfiles = length(files); %Kaç adet dosya olduðu belirlenmiþtir. Doðru sayýda dosyanýn okunduðunu öðrenmek amaçlýdýr.
operet=[1,2,3,4,5]; %files struct'ýnda toparlanmýþ verilerin iþlenme sýrasý
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

data_A=fscanf(file_A,'%g',2*N); % okunmuþ olan frekans cevap fonksiyonun reel ve imajiner kýsýmlarý ayný veride okunur. 
%tek sayý satýrlar reel kýsýmdýr, çift sayý satýrdakiler imajiner sayýdýr

real_A=data_A(1:2:end); %reel sayýlar ayrýþtýrýlýr
imag_A=j*data_A(2:2:end); %imajiner sayýlar ayrýþtýrýlýr


H=real_A+imag_A; %Ýnertans, kompleks düzlemde elde edilir. 
recA(:,J)=-(H./w_2); %reseptans verisi kompleks düzlemde elde edilir.
abs_recA=abs(recA(:,J)); %kompleks düzlemdeki reseptansýn mutlak deðeri bulunur.
rec_dataA(:,J)=20*log10(abs_recA); %reseptans logaritmik düzlemde yazýlýr.
phaseA(:,J)=radtodeg(angle(recA(:,J))); %Her bir noktanýn faz deðeri elde edilir. 
end
%elde edilen grafikler tanýmlanýr.
    olcumdk={'kontrol';'12nci dk';'26nci dk';'36nci dk';'47nci dk';'59nci dk';
    '67nci dk';'80nci dk';'91nci dk';'98nci dk';'107nci dk';'123nci dk';'135nci dk'};
%grafiklerin baþlýklarý tanýmlanýr.

% fig_ciz(freq,rec_dataA,phaseA,'Reseptans (dB/m/N)','Faz Açýsý (Deg)')


%% Line-Fit Uygulanýr
for Zet=1:length(operet)
[pks lkm]=findpeaks(rec_dataA(:,Zet),'minpeakdistance',1000); %tepe noktalar belirlenir. 
p=1;
for I=1:length(lkm) %analiz edilecek tepe noktalarý seçilir.
    freq(lkm(I)) %frekans gösterilir.
    flag=input('1 mi 0 mý?') %seçilecekse 1, ihmal edilecekse 0 tuþlanýr.
    if flag==1 %seçilmiþ frekans söz konusuysa modal analiz baþlar,
fmin=freq(lkm(I))-15; %analiz edilecek alt sýnýr belirlenir
fmax=freq(lkm(I))+15; %analiz edilecek üst sýnýr belirlenir.

[freq_local,H_local,H_gen_local,infoMODE,line_prop] = line_fit(recA(:,Zet),freq',fmin,fmax) ; %line fit yöntemi uygulanýr.
plot_line_fit(freq_local,H_local,H_gen_local,infoMODE,line_prop) %line fit yönteminde elde edilen verilerden grafikler elde edilir 

if flag==1 %elde edilen modal parametre 0'dan farklý ise
rezf(p)=infoMODE.frequencyk; % Belirlenen doðal frekans kaydedilir.
damp(p)=infoMODE.etak; %Belirlenen sönüm katsayýsý kaydedilir.
mode(p)=infoMODE.Bijk; %Belirnen modal parametre kaydedilir
p=p+1; %sayaç indisi
end

%line fit ile elde edilen grafik kaydedilir. 
% DD1=num2str(fix(rezf(p-1)));
% DD2='(Hz) deki modun modal analizi';
% formatspec='%1$s %2$s';
% C2=sprintf(formatspec, DD1,DD2);
% fig_kaydet(olcumdk{Zet},C2)

    else
        continue
    end
end
%% Frekans cevap fonksiyonu ile uydurulmuþ eðri karþýlaþtýrýlýr.        
for J=1:p-1;
    s=1;
    rezfw=2*pi*rezf;
        for M=linspace(min(freq),max(freq),N)
            ww=2*pi*M;
            Hs(s,J)=mode(J)/complex(ww^2-rezfw(J)^2,damp(J)*rezfw(J)^2);
            s=s+1;
        end
end
Hgen_glo=0;
for J=1:p-1
    Hgen_glo=Hgen_glo+Hs(:,J);
end
freqgen=linspace(0,freqmax,length(Hgen_glo));
abs_gloA=abs(Hgen_glo);
rec_gloA=20*log10(abs_gloA);

% plot(freqgen,rec_gloA,freqgen,rec_dataA(:,Zet)), grid, xlabel 'frekans(Hz)', ylabel 'reseptans(dB/m/N)', title 'Sistemin Frekans Cevabý', legend
% saveas(gca,'karþýlaþtýrma','jpg')

%% farklý iki frekans cevap fonksiyonu ile 
if p==2 %tek bir mod þeklinin analiz edildiði anlaþýlmaktadýr. Bu durumda farklý frekans cevap fonksiyonlarý karþýlaþtýrýlmaktadýr. 
grezf(Zet)=infoMODE.frequencyk;
gdamp(Zet)=infoMODE.etak;
gmode(Zet)=infoMODE.Bijk;
end
end
%% Modal parametreler elde edilmesi 
Ajk=abs(gmode);
MOD(point)=sqrt(Ajk(point)); %pivot noktasýndaki modal çarpan elde edilir.
for I=1:length(Ajk)
    if I==point
        continue
    elseif I~=point
        MOD(I)=Ajk(I)/MOD(point); %pivot üzerinden diðer modal çarpanlar elde edilir. 
    end
end


%p=1 durumunda karþýlaþtýrmalý grafiklerin çizilmesi 
% if p==2
% Tdk=[12,26,36,47,59,67,80,91,98,107,123,135];
% dinamik_kar_fig(Tdk,gdamp(2:end)./2,'Farklý Zamanlarda',' Sönüm Oraný')
% dinamik_kar_fig(Tdk,MOD(2:end),'Farklý Zamanlarda',' Modal Parametre')
% dinamik_kar_fig(Tdk,grezf(2:end),'Farklý Zamanlarda','Doðal Frekans (Hz)')
% end