function [MAC,AMAC]=MAC(fiex,fian)
[r c]=size(fiex);
MAC=zeros(5);
AMAC=zeros(5);
for I=1:c %analitical indeces of modal shape vectors
    for J=1:c %experimental indeces of modal shape vectors
    MAC(I,J)=abs(fiex(:,J)'*fian(:,I))^2/((fiex(:,J)'*fiex(:,J))*(fian(:,I)'*fian(:,I)));
    AMAC(I,J)=abs(fiex(:,J)'*fiex(:,I))^2/((fiex(:,J)'*fiex(:,J))*(fiex(:,I)'*fiex(:,I)));
    end
end    
