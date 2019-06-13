function plot_line_fit(freq_local,H_local,H_gen_local,infoMODE,line_prop)

% ------------------   This file is part of EasyMod   ----------------------------
%  User function
%
%  Graphical representation of the results provided by the function 'line_fit'.
%
%  Synthax:
%  plot_line_fit(freq_local,H_local,H_gen_local,infoMODE,line_prop)
% 
%  Input data:
%  freq_local: studied frequency vector extrated from the overall frequency,
%  H_local: studied FRF vector extrated from the overall FRF,
%  H_gen_local: synthetized FRF from modal parameters,
%  infoMODE: structure containing the difreqerent identified parameters
%                infoMODE.frequencyk = natural frequency
%                infoMODE.etak = loss factor
%                infoMODE.Bijk = modal constant,
%  line_prop: structure containing information about the line-fit method.
%          
%  These data are directly obtained with the function 'line_fit'.
%
% Copyright (C) 2012 David WATTIAUX, Georges KOUROUSSIS


%  Necessary functions: 
%  -----------------------------------------------------------
%  err_fit_circle.m


if isempty(infoMODE.frequencyk) == 0

% Determination of Nyquist's circle using least squares method    
x = real(H_local) ;
y = imag(H_local) ;
[x0,y0,R0] = err_fit_circle(x,y) ;

% Modal properties
freq_local = line_prop.freq_local ;
ww_local = 2*pi*freq_local ;
ff_Delta = 2*pi*line_prop.ww_Delta ;
eig_frequency = infoMODE.frequencyk ;
loss_factor = infoMODE.etak ;
B = infoMODE.Bijk ;

% Lines properties
Delta =line_prop.Delta ;
tr = line_prop.tr ;
ti = line_prop.ti ;
ur = line_prop.ur ;
dr = line_prop.dr ;
ui = line_prop.ui ;
di = line_prop.di ;

figure('position', [50, 50, 1600, 800]) 


% FRF building
h(1)=subplot(2,2,1) ;
plot(freq_local,20*log10(abs(H_gen_local)),'color','r','Linewidth',1) ;
hold on ;
plot(freq_local,20*log10(abs(H_local)),'Linewidth',1) ;
grid on ;
hh(1)=xlabel('Frequency  [Hz]') ;
hh(2)=ylabel('Gain  [dB]') ;
hh(3)=title('Bode curve') ;
legend('generated FRF','measured FRF',4) ;

% Nyquist's circle visualization
h(2)=subplot(2,2,2) ;
plot(x,y,'*','Linewidth',1) ;
hold on ;
t = 0:0.01:2*pi ;
plot(R0*sin(t)+x0,R0*cos(t)+y0,'color','r','Linewidth',1) ;
hh(4)=xlabel('Real part FRF') ;
hh(5)=ylabel('Imaginary part FRF') ;
hh(6)=title('Nyquist curve') ;

% Various lines visualization
h(3)=subplot(4,4,11) ;
plot(freq_local.^2,real(Delta),'color','b') ;
hh(7)=ylabel('Delta') ;
hh(8)=title('Real part') ;
xlim([min(freq_local.^2) max(freq_local.^2)]) ;
h(4)=subplot(4,4,12) ;
plot(freq_local.^2,imag(Delta),'color','b') ;
hh(9)=title('Imaginary part') ;
xlim([min(freq_local.^2) max(freq_local.^2)]) ;
h(5)=subplot(4,4,15) ;
plot(freq_local.^2,tr,'*','color','green','MarkerSize',3) ;
hold on ;
plot(freq_local.^2,ur*(ww_local.^2)+dr,'color','r','LineWidth',1) ;
hh(10)=ylabel('Slope') ;
hh(11)=xlabel('Square Frequency  [Hz^2]') ;
xlim([min(freq_local.^2) max(freq_local.^2)]) ;
h(6)=subplot(4,4,16) ;
plot(freq_local.^2,ti,'*','color','green','MarkerSize',3) ;
hold on ;
plot(freq_local.^2,ui*(ww_local.^2)+di,'color','r','LineWidth',1) ;
hh(12)=xlabel('Square Frequency  [Hz^2]') ;
xlim([min(freq_local.^2) max(freq_local.^2)]) ;

set(h(1:6),'FontSize',14,'FontName','NewTimesRoman')
set(hh(1:12),'FontSize',14,'FontName','NewTimesRoman')
% Results displaying
set(uicontrol,'style','text','FontSize',14,'FontName','NewTimesRoman','position',[250 230 300 25],'string','Natural frequency [Hz]:') ;
set(uicontrol,'style','text','FontSize',14,'FontName','NewTimesRoman','position',[250 205 300 25],'string','Damping constant [%]:') ;
set(uicontrol,'style','text','FontSize',14,'FontName','NewTimesRoman','position',[250 180 300 25],'string','Modal Const MAG:') ;
set(uicontrol,'style','text','FontSize',14,'FontName','NewTimesRoman','position',[250 155 300 25],'string','Modal Const phase [°]:') ;
but1=uicontrol('style','text','position',[550 230 95 25]) ;
but2=uicontrol('style','text','position',[550 205 95 25]) ;
but3=uicontrol('style','text','position',[550 180 95 25]) ;
but4=uicontrol('style','text','position',[550 155 95 25]) ;
Bmod = abs(B) ;
phi = atan2(imag(B),real(B))*360/(2*pi) ;
set(but1,'FontSize',14,'FontName','NewTimesRoman','string',eig_frequency) ;
set(but2,'FontSize',14,'FontName','NewTimesRoman','string',loss_factor/2*100) ;
set(but3,'FontSize',14,'FontName','NewTimesRoman','string',Bmod) ;
set(but4,'FontSize',14,'FontName','NewTimesRoman','string',phi) ;

elseif isempty(infoMODE.frequencyk) == 1
    figure
end

