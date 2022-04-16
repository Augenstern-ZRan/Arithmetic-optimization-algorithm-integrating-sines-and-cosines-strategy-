%算术优化算法
function [Best_FF,Best_P,Conv_curve]=AOA(N,M_Iter,LB,UB,Dim,F_obj)

Best_FF=inf;                %最优值
Best_P=zeros(1,Dim);        %最优解
Conv_curve=zeros(1,M_Iter); %历代最优值

%初始化各参数
MOA_Max=1;
MOA_Min=0.2;
Alpha=5;
Mu=0.499;   

%初始化种群
X=initialization(N,Dim,UB,LB);

%找到初始最优解
Ffun=zeros(1,size(X,1));
for i=1:size(X,1)
    Ffun(1,i)=F_obj(X(i,:));  %计算适应度值
    if Ffun(1,i)<Best_FF
        Best_FF=Ffun(1,i);
        Best_P=X(i,:);
    end
end

Xnew=X; %存放新解
Ffun_new=Ffun;%存放新适应度
C_Iter=1;
while C_Iter<M_Iter+1  %开始迭代寻优
    
    MOA=MOA_Min+C_Iter*((MOA_Max-MOA_Min)/M_Iter);   %更新数优化器加速函数
    MOP=1 - ((C_Iter)^(1/Alpha)/(M_Iter)^(1/Alpha));   %更新数学优化器概率
     
    %更新每个个体的位置
    for i=1:size(X,1)
        for j=1:size(X,2)
            r1=rand();
            if r1>MOA                                %全局搜索阶段
                r2=rand();
                if r2<0.5
                    Xnew(i,j)=Best_P(1,j)/(MOP+eps)*((UB-LB)*Mu+LB);
                else
                    Xnew(i,j)=Best_P(1,j)*MOP*((UB-LB)*Mu+LB);
                end
            else                                     %局部搜索阶段
                r3=rand();
                if r3<0.5
                    Xnew(i,j)=Best_P(1,j) - MOP*((UB-LB)*Mu+LB);
                else
                    Xnew(i,j)=Best_P(1,j) + MOP*((UB-LB)*Mu+LB);
                end
            end
        end
        
        %边界处理
        Flag_UB=Xnew(i,:)>UB;
        Flag_LB=Xnew(i,:)<LB;
        Xnew(i,:)=(Xnew(i,:).*(~(Flag_UB+Flag_LB)))+UB.*Flag_UB+LB.*Flag_LB;
        
        Ffun_new(1,i)=F_obj(Xnew(i,:));     %评估新解
        if Ffun_new(1,i)<Ffun(1,i)
            X(i,:)=Xnew(i,:);
            Ffun(1,i)=Ffun_new(1,i);
        end
        
        if Ffun(1,i)<Best_FF    %更新当前最优解
            Best_FF=Ffun(1,i);
            Best_P=X(i,:);
        end
    end
    
    %记录历代最优值
    Conv_curve(C_Iter)=Best_FF;
       
    C_Iter=C_Iter+1;  
end

