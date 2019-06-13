function fig_kaydet(C1,C2)
formatSpec = '%1$s %2$s';
strtt = sprintf(formatSpec,C1,C2);
figuresdir ='C:\Users\oguzhan\Desktop\Tez_biyomekanik\Tekrarlanabilirlik\koyun_tibia_tekrarlanabilirlik\Sonuclar\';
set(gcf, 'PaperUnits', 'inches');
x_width=15 ;y_width=12;
set(gcf, 'PaperPosition', [0 0 x_width y_width])
saveas(gcf,strcat(figuresdir, strtt), 'jpeg');
saveas(gcf,strcat(figuresdir, strtt), 'fig');
saveas(gcf,strcat(figuresdir, strtt), 'eps');