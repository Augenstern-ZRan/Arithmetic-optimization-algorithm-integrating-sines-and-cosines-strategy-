function [fmin,best_pos,Convergence_curve]=PSO(n,N_iter,Lb,Ub,dim,fobj)

%% 初始化参数
c1 = 1.5;%学习因子1
c2 = 1.5;%学习因子2
% w = 0.8;%惯性权重
Vmax = 0.5;%速度最大值
Vmin = -0.5;%速度最小值
%% 初始化种群粒子位置x和速度v
x = rand(n,dim)*(Ub-Lb) + Lb;
v = rand(n,dim)*(Vmax-Vmin) + Vmin;
%% 初始化粒子个体最优位置p和最优值pbest
p = x;
pbest = ones(n,1);
for i = 1:n
    pbest(i) = fobj(p(i,:));
end
%% 初始化粒子群全局最优位置g和最优值gbest
g = ones(1,dim);
gbest = inf;
for i = 1:n
    if(pbest(i)<gbest)
        g = p(i,:); 
        gbest = pbest(i);
    end
end
Convergence_curve = ones(1,N_iter);  %历代全局最优值
%% 按照公式依次迭代直到满足精度或迭代次数
for i = 1:N_iter
    for j = 1:n
        %% 更新个体最优位置和最优值
        if fobj(x(j,:)) < pbest(j)
            p(j,:) = x(j,:);
            pbest(j) = fobj(x(j,:));
        end
        %% 更新全局最优位置和最优值
        if pbest(j) < gbest
            g = p(j,:);
            gbest = pbest(j);
        end
        %% 更新位置和速度值
        v(j,:) = v(j,:) + c1*rand*(p(j,:)-x(j,:)) + c2*rand*(g-x(j,:));
        x(j,:) = x(j,:) + v(j,:);
        %% 边界处理
        for ii=1:dim
            if (x(j,ii)>Ub || x(j,ii)<Lb)
                x(j,ii) = Lb + rand*(Ub-Lb);
            end
            if (v(j,ii)>Vmax || x(j,ii)<Vmin)
                x(j,ii) = Vmin + rand*(Vmax-Vmin);
            end
        end
    end
    %% 记录历代全局最优值  
    Convergence_curve(i) = gbest;
end
best_pos = g;
fmin = gbest;
