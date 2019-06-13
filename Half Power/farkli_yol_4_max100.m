clear
clc
files = dir('frf_*.uff');
nfiles = length(files);
operet=[1 2 3 4 5 6 7 8 9 10 11 12 14 15 16 17 20 21];
for I=operet
    I
    infile = files(I).name;   
    file_A=fopen(infile,'r');
% unnecessary datas is removed
for i=1:13
    unnecesseryA=fgetl(file_A);
end
% Frequency is defiend
w=0:0.25:99.75;
w_2=(w.^2).';

% Taking all datas (real and imaginery parts are at the same matrix)
data_A=fscanf(file_A,'%g',800);

% Seperation of real and imaginary parts
real_A=data_A(1:2:end);
imag_A=j*data_A(2:2:end);

% Adding these datas (real+imaginary)
%A.uff
A=real_A+imag_A;
indi=find(operet==I);
recA=-(A./w_2);
alfa(:,indi)=recA;
abs_recA=abs(recA);
rec_dataA=20*log10(abs_recA);
phaseA=radtodeg(angle(recA));
inerA=abs(A);
iner_phaseA=radtodeg(angle(A));
%%
Plotting A.uff
figure(I)
subplot(2,1,1)
plot(w,rec_dataA)
grid on
title('Frequency Response Function - Receptance vs Frequency(A.uff)')
xlabel('Frequency (Hz)')
ylabel('Receptance(dB scale)')

subplot(2,1,2)
plot(w,phaseA)
grid on
title('Frequency Response Function - Phase vs Frequency(A.uff)')
xlabel('Frequency (Hz)')
ylabel('Phase Angle (Deg)')

%%


% ========================PARAMETER ESTIMATION============================%
LOCAM=[33;107;139];
for z=1:3
[PEAKS,LOCA] = findpeaks(rec_dataA(LOCAM(z,1)-6:LOCAM(z,1)+6,1),'MINPEAKDISTANCE',10);
W=w(find(PEAKS==rec_dataA)).';


n=zeros(length(PEAKS),1);
for i=1:length(PEAKS)
    limit_down=PEAKS(i)-3;
    limit_up=PEAKS(i)-3;
    down_number=find(PEAKS(i)==rec_dataA)-1;
    up_number=find(PEAKS(i)==rec_dataA)+1;
    value_down=(rec_dataA(down_number));
    value_up=(rec_dataA(up_number));
    freq_peak=w(find(PEAKS(i)==rec_dataA));

while value_down > limit_down;
    down_number=down_number-1;
    value_down=(rec_dataA(down_number));
        if down_number<=1
            break
        else
            continue
        end
end
freq_down=w(find(value_down==rec_dataA));
w1=freq_peak-(3*(freq_peak-freq_down))/(PEAKS(i)-value_down);

while value_up > limit_up;
    up_number=up_number+1;
    value_up=(rec_dataA(up_number));
        if up_number>=400
            break
        else
            continue
        end
end
freq_up=w(find(value_up==rec_dataA));
w2=freq_peak-(3*(freq_peak-freq_up))/(PEAKS(i)-value_up);
n=abs((w1-w2))/freq_peak;
results(z,I) = struct('Peaks',PEAKS,'Frequencies',W,'nu_values',n)
end
%results=zeros(5,length(PEAKS));

% results{1,I}.Peaks(1,:)=transpose(PEAKS);
% results{2,I}.Frequencies=transpose(W);
% results{3,I}.nu_values=transpose(n);
end
end
% ======================EXPERÝMENTAL MODAL SHAPE ======================%
% =========================== PREDÝCTED FRFS ===========================%
% =================================MAC====================================%

for j=1:length(operet)
for i=1:3
n(i,j)=results(i,operet(j)).nu_values;
wn(i,j)=results(i,operet(j)).Frequencies;
end
end
n=n';
wn=2*pi.*wn';
w=2*pi.*w;
[fiex]=modshfind(w,wn,n,alfa,operet);
[frf_top_an, frf_real_an, frf_img_an]=modan(w,wn,fiex,n,operet);
load('frf_FEM.mat');
for I=1:3
    imagfiex=imag(fiex(:,I))./max(abs(imag(fiex(:,I))));
    normmodex=real(fiex(:,I))./max(abs(real(fiex(:,I))));
    normmodan=real(fian(:,I))./max(abs(real(fian(:,I))));
    fiex(:,I)=normmodex+sqrt(-1)*imagfiex;
end
magfiex=abs(fiex);

[macc amacc]=MAC(magfiex,fian);

% ========PLOTING TO COMPARISION BETWEEN THEORETICAL-PREDÝCTED-FEM========%
% ===============================RESULTS==================================%

for I=1:3
    phasefiex(:,I)=radtodeg(angle(fiex(:,I)));
    refphase=phasefiex(6,I);
    phasefiex(:,I)=phasefiex(:,I)-refphase;
    figure(I)
    compass(fiex(:,I))
end

w=w./(2*pi)
[r c]=size(frf_top_an)
for I=1:(c)
    figure(I)
    plot(w,20.*log10(abs(alfa(:,I))),w,20.*log10(abs(frf_top_an(:,I))),w_FEM,(frf_FEM(:,operet(I))))
    grid on, xlabel 'frequency [Hz]', ylabel 'receptance', title 'comparision between theoretical and analtical resuts'
    legend('experimental','curve fit','FEM')
    saveas(gca,num2str(operet(I)),'jpg')
end

pcolor(-amacc')
colormap(gray(100))
axis -ij
