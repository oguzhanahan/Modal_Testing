function fig_ciz(freq,rec_dataA,phaseA,str1,str2)
%% grafik kaydetme program�
% Yazan: A. O�uzhan Ahan

[~,c]=size(rec_dataA); %okunan frekans cevap fonksiyonlar�n�n biriktirildi�i de�i�kenin boyutunu ��renir.
    s={'kontrol';'12nci dk';'26nci dk';'36nci dk';'47nci dk';'59nci dk';
    '67nci dk';'80nci dk';'91nci dk';'98nci dk';'107nci dk';'123nci dk';'135nci dk'};
for I=1:c %�l��len frekans cevap fonksiyonu kadar i�lem yap�laca��n� anlar

figure('position', [50, 50, 1200, 600]) % grafik boyutu belirlenir

%frekans cevap fonksiyonu yaz�l�r
h(1)=subplot(1,2,1);
plot(freq,rec_dataA(:,I),'k','LineWidth',2) 
format_ayar(s{I},str1)

%frekans cevap fonksiyonu yaz�l�r
h(2)=subplot(1,2,2);
plot(freq,phaseA(:,I),'k','LineWidth',2) 
format_ayar(s{I},str2)

%�izilen grafiklerin apsis ve ordinant limitleri belirlenir. 
set(h(1),'Xlim',[0,3200],'YLim',[-160 -20])
set(h(2),'Xlim',[0,3200],'YLim',[-200 200])

%grafikler .esp, .fig ve .jpg formatta, uygun isimde kaydedilir. 
fig_kaydet(s{I},'�l��m�nde G�r�len Reseptans')
end

%% a�a��da yap�lan i�lem, yukar�da ger�ekle�tirilen i�lem ile ayn� olup, b�t�n fonksiyonlar� tek bir grafikte g�stermek ama�l�d�r.

figure('position', [50, 50, 1200, 600]) 

h(1)=subplot(1,2,1);
plot(freq,rec_dataA,'LineWidth',2)
format_ayar('2 Nolu Numunedeki',str1)
legend(s)


h(2)=subplot(1,2,2);
plot(freq,phaseA,'LineWidth',2)
format_ayar('2 Nolu Numunedeki',str2)


set(h(1),'Xlim',[0,3200],'YLim',[-160 -20])
set(h(2),'Xlim',[0,3200],'YLim',[-200 200])

fig_kaydet('2 Nolu Numune','�l��m�nde G�r�len Reseptanslar')

