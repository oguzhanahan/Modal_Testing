function dinamik_kar_fig(zaman,plot_var,dosya_adi,str)
figure('position', [50, 50, 600, 600]) 
plot(zaman,plot_var,'k','LineWidth',2);
set(gca,'FontSize',14)
set(gca,'FontName','NewTimesRoman')
A3 = str;
A2='Ölçülen';
A1 = dosya_adi; 
formatSpec = '%1$s %2$s %3$s';
strtt = sprintf(formatSpec,A1,A2,A3);
title(strtt,'FontSize',14,'FontName','TimesNewRoman')
xlabel('Vuruþ Dakikasý (dk)','FontSize',14,'FontName','TimesNewRoman')
ylabel(str,'FontSize',14,'FontName','TimesNewRoman')
grid

axis([zaman(1) zaman(length(zaman)) min(plot_var)*0.99 max(plot_var)*1.001])

fig_kaydet(dosya_adi,str)