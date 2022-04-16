function [fmin,best_pos,Convergence_curve]=PSO(n,N_iter,Lb,Ub,dim,fobj)

%% ��ʼ������
c1 = 1.5;%ѧϰ����1
c2 = 1.5;%ѧϰ����2
% w = 0.8;%����Ȩ��
Vmax = 0.5;%�ٶ����ֵ
Vmin = -0.5;%�ٶ���Сֵ
%% ��ʼ����Ⱥ����λ��x���ٶ�v
x = rand(n,dim)*(Ub-Lb) + Lb;
v = rand(n,dim)*(Vmax-Vmin) + Vmin;
%% ��ʼ�����Ӹ�������λ��p������ֵpbest
p = x;
pbest = ones(n,1);
for i = 1:n
    pbest(i) = fobj(p(i,:));
end
%% ��ʼ������Ⱥȫ������λ��g������ֵgbest
g = ones(1,dim);
gbest = inf;
for i = 1:n
    if(pbest(i)<gbest)
        g = p(i,:); 
        gbest = pbest(i);
    end
end
Convergence_curve = ones(1,N_iter);  %����ȫ������ֵ
%% ���չ�ʽ���ε���ֱ�����㾫�Ȼ��������
for i = 1:N_iter
    for j = 1:n
        %% ���¸�������λ�ú�����ֵ
        if fobj(x(j,:)) < pbest(j)
            p(j,:) = x(j,:);
            pbest(j) = fobj(x(j,:));
        end
        %% ����ȫ������λ�ú�����ֵ
        if pbest(j) < gbest
            g = p(j,:);
            gbest = pbest(j);
        end
        %% ����λ�ú��ٶ�ֵ
        v(j,:) = v(j,:) + c1*rand*(p(j,:)-x(j,:)) + c2*rand*(g-x(j,:));
        x(j,:) = x(j,:) + v(j,:);
        %% �߽紦��
        for ii=1:dim
            if (x(j,ii)>Ub || x(j,ii)<Lb)
                x(j,ii) = Lb + rand*(Ub-Lb);
            end
            if (v(j,ii)>Vmax || x(j,ii)<Vmin)
                x(j,ii) = Vmin + rand*(Vmax-Vmin);
            end
        end
    end
    %% ��¼����ȫ������ֵ  
    Convergence_curve(i) = gbest;
end
best_pos = g;
fmin = gbest;
