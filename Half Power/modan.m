function [frf_top_an, frf_real_an, frf_img_an]=modan(w,wr,fi,nu,coordi)
[c ci]=size(wr);
r=length(coordi);
for I=1:ci
    for J=1:r
        for K=1:length(w)
        frf_an(K,1)=0;
            for r=1:3
        zeta=(fi(6,I)*fi(J,1))/(wr(J,r)^2-w(K)^2+sqrt(-1)*nu(J,r)*wr(J,r)^2);
        frf_an(K,1)=frf_an(K,1)+zeta;
            end
        end
    frf_top_an(:,J)=frf_an;
    frf_real_an=real(frf_top_an);
    frf_img_an=imag(frf_top_an);
    end
end