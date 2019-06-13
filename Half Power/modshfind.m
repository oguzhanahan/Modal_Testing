function [fi] = modshfind(w,wn,nu,alfa,operet)
fprintf('coordinates are %g\f' , operet)
if length(operet)<=1
    disp('not enough number of coordinates')
end
[r c]=size(wn);
p_frf=input('point frf point?');
disp(p_frf)
for I=1:c
    b=find(w==wn(1,I));
    fi(p_frf,I)=sqrt(alfa(b,p_frf)*(sqrt(-1)*nu(6,I)*wn(6,I)^2));
for J=1:length(operet)
    if J~=p_frf
        fi(J,I)=alfa(b,J)*(sqrt(-1)*nu(J,I)*wn(J,I)^2)/fi(p_frf,I);
    elseif J==p_frf
        fi(J,I)=fi(p_frf,I);
    end
end
end
