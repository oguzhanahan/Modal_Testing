function fig_ciz(freq,rec_dataA,phaseA,str1,str2)
%% grafik kaydetme programý
% Yazan: A. Oðuzhan Ahan

[~,c]=size(rec_dataA); %okunan frekans cevap fonksiyonlarýnýn biriktirildiði deðiþkenin boyutunu öðrenir.
    s={'kontrol';'12nci dk';'26nci dk';'36nci dk';'47nci dk';'59nci dk';
    '67nci dk';'80nci dk';'91nci dk';'98nci dk';'107nci dk';'123nci dk';'135nci dk'};
for I=1:c %ölçülen frekans cevap fonksiyonu kadar iþlem yapýlacaðýný anlar

figure('position', [50, 50, 1200, 600]) % grafik boyutu belirlenir

%frekans cevap fonksiyonu yazýlýr
h(1)=subplot(1,2,1);
plot(freq,rec_dataA(:,I),'k','LineWidth',2) 
format_ayar(s{I},str1)

%frekans cevap fonksiyonu yazýlýr
h(2)=subplot(1,2,2);
plot(freq,phaseA(:,I),'k','LineWidth',2) 
format_ayar(s{I},str2)

%çizilen grafiklerin apsis ve ordinant limitleri belirlenir. 
set(h(1),'Xlim',[0,3200],'YLim',[-160 -20])
set(h(2),'Xlim',[0,3200],'YLim',[-200 200])

%grafikler .esp, .fig ve .jpg formatta, uygun isimde kaydedilir. 
fig_kaydet(s{I},'Ölçümünde Görülen Reseptans')
end

%% aþaðýda yapýlan iþlem, yukarýda gerçekleþtirilen iþlem ile ayný olup, bütün fonksiyonlarý tek bir grafikte göstermek amaçlýdýr.

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

fig_kaydet('2 Nolu Numune','Ölçümünde Görülen Reseptanslar')

