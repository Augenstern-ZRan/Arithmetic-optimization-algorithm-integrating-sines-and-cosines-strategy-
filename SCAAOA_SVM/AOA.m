%�����Ż��㷨
function [Best_FF,Best_P,Conv_curve]=AOA(N,M_Iter,LB,UB,Dim,F_obj)

Best_FF=inf;                %����ֵ
Best_P=zeros(1,Dim);        %���Ž�
Conv_curve=zeros(1,M_Iter); %��������ֵ

%��ʼ��������
MOA_Max=1;
MOA_Min=0.2;
Alpha=5;
Mu=0.499;   

%��ʼ����Ⱥ
X=initialization(N,Dim,UB,LB);

%�ҵ���ʼ���Ž�
Ffun=zeros(1,size(X,1));
for i=1:size(X,1)
    Ffun(1,i)=F_obj(X(i,:));  %������Ӧ��ֵ
    if Ffun(1,i)<Best_FF
        Best_FF=Ffun(1,i);
        Best_P=X(i,:);
    end
end

Xnew=X; %����½�
Ffun_new=Ffun;%�������Ӧ��
C_Iter=1;
while C_Iter<M_Iter+1  %��ʼ����Ѱ��
    
    MOA=MOA_Min+C_Iter*((MOA_Max-MOA_Min)/M_Iter);   %�������Ż������ٺ���
    MOP=1 - ((C_Iter)^(1/Alpha)/(M_Iter)^(1/Alpha));   %������ѧ�Ż�������
     
    %����ÿ�������λ��
    for i=1:size(X,1)
        for j=1:size(X,2)
            r1=rand();
            if r1>MOA                                %ȫ�������׶�
                r2=rand();
                if r2<0.5
                    Xnew(i,j)=Best_P(1,j)/(MOP+eps)*((UB-LB)*Mu+LB);
                else
                    Xnew(i,j)=Best_P(1,j)*MOP*((UB-LB)*Mu+LB);
                end
            else                                     %�ֲ������׶�
                r3=rand();
                if r3<0.5
                    Xnew(i,j)=Best_P(1,j) - MOP*((UB-LB)*Mu+LB);
                else
                    Xnew(i,j)=Best_P(1,j) + MOP*((UB-LB)*Mu+LB);
                end
            end
        end
        
        %�߽紦��
        Flag_UB=Xnew(i,:)>UB;
        Flag_LB=Xnew(i,:)<LB;
        Xnew(i,:)=(Xnew(i,:).*(~(Flag_UB+Flag_LB)))+UB.*Flag_UB+LB.*Flag_LB;
        
        Ffun_new(1,i)=F_obj(Xnew(i,:));     %�����½�
        if Ffun_new(1,i)<Ffun(1,i)
            X(i,:)=Xnew(i,:);
            Ffun(1,i)=Ffun_new(1,i);
        end
        
        if Ffun(1,i)<Best_FF    %���µ�ǰ���Ž�
            Best_FF=Ffun(1,i);
            Best_P=X(i,:);
        end
    end
    
    %��¼��������ֵ
    Conv_curve(C_Iter)=Best_FF;
       
    C_Iter=C_Iter+1;  
end

