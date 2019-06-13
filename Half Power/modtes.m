clc
clear
svdec
%%%% nu deðeri buradan hesaplanacak %%%%%
[fiex coordi]=modshfind(w,wn,nu,alfa);
[frf_top_an, frf_real_an, frf_img_an]=modan(w,wn,fiex,nu,coordi);
fian=modshfind(w,wn,nu,frf_top_an);
[macc amacc]=MAC(fiex,fian);