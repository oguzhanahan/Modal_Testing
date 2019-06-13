function format_ayar(dosya_adi,str)
% Bu program, fiz_ciz.m fonksiyonu ile çizilecek olan grafiðin formatýný ayarlar
% Yazan: A. Oðuzhan Ahan
set(gca,'FontSize',14)
set(gca,'FontName','NewTimesRoman')
A3 = str;
A2='Ölçülen';
A1 = dosya_adi; 
formatSpec = '%1$s %2$s %3$s';
strtt = sprintf(formatSpec,A1,A2,A3);
title(strtt,'FontSize',14,'FontName','TimesNewRoman')
xlabel('Frekans(Hz)','FontSize',14,'FontName','TimesNewRoman')
ylabel(str,'FontSize',14,'FontName','TimesNewRoman')
grid