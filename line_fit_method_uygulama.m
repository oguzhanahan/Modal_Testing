%% Modal analiz Program�
%Yazan: A.O�uzhan Ahan
%Bu Program, .uff uzant�l� olarak elde edilen frekans cevap fonksiyonlar�n� 
%okuyarak i�ler. Her bir parametrenin yanlar�na anlamlar� ili�tirilmi�.
%bu �ekilde takip etmesi daha kolay bir kod elde edilmesi ama�lanm��t�r.
%% �l��m ko�ullar� Tan�mlan�r. 
clear 
clc
freqmax=3200; %Nyquist Frekans�, Hz
N=6400; % �rnekleme Zaman�, Hz
point=7; %�eki� testindeki pivot noktas�
df=freqmax/N; %��z�n�rl�k
freqn=df; 
files = dir('frf_*.uff'); %frf_ ile ba�layan b�t�n dosyalar okunmaktad�r. 
nfiles = length(files); %Ka� adet dosya oldu�u belirlenmi�tir. Do�ru say�da dosyan�n okundu�unu ��renmek ama�l�d�r.
operet=[1,2,3,4,5]; %files struct'�nda toparlanm�� verilerin i�lenme s�ras�
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

data_A=fscanf(file_A,'%g',2*N); % okunmu� olan frekans cevap fonksiyonun reel ve imajiner k�s�mlar� ayn� veride okunur. 
%tek say� sat�rlar reel k�s�md�r, �ift say� sat�rdakiler imajiner say�d�r

real_A=data_A(1:2:end); %reel say�lar ayr��t�r�l�r
imag_A=j*data_A(2:2:end); %imajiner say�lar ayr��t�r�l�r


H=real_A+imag_A; %�nertans, kompleks d�zlemde elde edilir. 
recA(:,J)=-(H./w_2); %reseptans verisi kompleks d�zlemde elde edilir.
abs_recA=abs(recA(:,J)); %kompleks d�zlemdeki reseptans�n mutlak de�eri bulunur.
rec_dataA(:,J)=20*log10(abs_recA); %reseptans logaritmik d�zlemde yaz�l�r.
phaseA(:,J)=radtodeg(angle(recA(:,J))); %Her bir noktan�n faz de�eri elde edilir. 
end
%elde edilen grafikler tan�mlan�r.
    olcumdk={'kontrol';'12nci dk';'26nci dk';'36nci dk';'47nci dk';'59nci dk';
    '67nci dk';'80nci dk';'91nci dk';'98nci dk';'107nci dk';'123nci dk';'135nci dk'};
%grafiklerin ba�l�klar� tan�mlan�r.

% fig_ciz(freq,rec_dataA,phaseA,'Reseptans (dB/m/N)','Faz A��s� (Deg)')


%% Line-Fit Uygulan�r
for Zet=1:length(operet)
[pks lkm]=findpeaks(rec_dataA(:,Zet),'minpeakdistance',1000); %tepe noktalar belirlenir. 
p=1;
for I=1:length(lkm) %analiz edilecek tepe noktalar� se�ilir.
    freq(lkm(I)) %frekans g�sterilir.
    flag=input('1 mi 0 m�?') %se�ilecekse 1, ihmal edilecekse 0 tu�lan�r.
    if flag==1 %se�ilmi� frekans s�z konusuysa modal analiz ba�lar,
fmin=freq(lkm(I))-15; %analiz edilecek alt s�n�r belirlenir
fmax=freq(lkm(I))+15; %analiz edilecek �st s�n�r belirlenir.

[freq_local,H_local,H_gen_local,infoMODE,line_prop] = line_fit(recA(:,Zet),freq',fmin,fmax) ; %line fit y�ntemi uygulan�r.
plot_line_fit(freq_local,H_local,H_gen_local,infoMODE,line_prop) %line fit y�nteminde elde edilen verilerden grafikler elde edilir 

if flag==1 %elde edilen modal parametre 0'dan farkl� ise
rezf(p)=infoMODE.frequencyk; % Belirlenen do�al frekans kaydedilir.
damp(p)=infoMODE.etak; %Belirlenen s�n�m katsay�s� kaydedilir.
mode(p)=infoMODE.Bijk; %Belirnen modal parametre kaydedilir
p=p+1; %saya� indisi
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
%% Frekans cevap fonksiyonu ile uydurulmu� e�ri kar��la�t�r�l�r.        
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

% plot(freqgen,rec_gloA,freqgen,rec_dataA(:,Zet)), grid, xlabel 'frekans(Hz)', ylabel 'reseptans(dB/m/N)', title 'Sistemin Frekans Cevab�', legend
% saveas(gca,'kar��la�t�rma','jpg')

%% farkl� iki frekans cevap fonksiyonu ile 
if p==2 %tek bir mod �eklinin analiz edildi�i anla��lmaktad�r. Bu durumda farkl� frekans cevap fonksiyonlar� kar��la�t�r�lmaktad�r. 
grezf(Zet)=infoMODE.frequencyk;
gdamp(Zet)=infoMODE.etak;
gmode(Zet)=infoMODE.Bijk;
end
end
%% Modal parametreler elde edilmesi 
Ajk=abs(gmode);
MOD(point)=sqrt(Ajk(point)); %pivot noktas�ndaki modal �arpan elde edilir.
for I=1:length(Ajk)
    if I==point
        continue
    elseif I~=point
        MOD(I)=Ajk(I)/MOD(point); %pivot �zerinden di�er modal �arpanlar elde edilir. 
    end
end


%p=1 durumunda kar��la�t�rmal� grafiklerin �izilmesi 
% if p==2
% Tdk=[12,26,36,47,59,67,80,91,98,107,123,135];
% dinamik_kar_fig(Tdk,gdamp(2:end)./2,'Farkl� Zamanlarda',' S�n�m Oran�')
% dinamik_kar_fig(Tdk,MOD(2:end),'Farkl� Zamanlarda',' Modal Parametre')
% dinamik_kar_fig(Tdk,grezf(2:end),'Farkl� Zamanlarda','Do�al Frekans (Hz)')
% end