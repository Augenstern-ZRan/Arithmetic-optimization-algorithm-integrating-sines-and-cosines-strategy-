%清空环境变量
clear;
close all;
clc;

Solution_no=30; %种群大小
% F_name='F1';    %目标函数名
M_Iter=500;     %最大迭代次数
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

for k =1:3 %（用于作图，每次运行测试3个函数）
    F_name=k;    %目标函数名 （此处将Get_Functions_details中的相应函数名改为数字即可调用）
    [LB,UB,Dim,F_obj]=Get_Functions_details(F_name); %获取目标函数

    %运行算法（30次）
    test_iteration = 2;

    PSO_fmins = zeros(1,test_iteration);
    PSO_curves = zeros(test_iteration,M_Iter);

    GWO_fmins = zeros(1,test_iteration);
    GWO_curves = zeros(test_iteration,M_Iter);

    WOA_fmins = zeros(1,test_iteration);
    WOA_curves = zeros(test_iteration,M_Iter);

    SSA_fmins = zeros(1,test_iteration);
    SSA_curves = zeros(test_iteration,M_Iter);

    AOA_fmins = zeros(1,test_iteration);
    AOA_curves = zeros(test_iteration,M_Iter);

    SCAAOA_fmins = zeros(1,test_iteration);
    SCAAOA_curves = zeros(test_iteration,M_Iter);

    for i = 1:test_iteration

        [PSO_fmin,PSO_bestX,PSO_curve]=PSO(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        PSO_fmins(i) = PSO_fmin;
        PSO_curves(i,:) = PSO_curve;

        [GWO_fmin,GWO_bestX,GWO_curve]=GWO(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        GWO_fmins(i) = GWO_fmin;
        GWO_curves(i,:) = GWO_curve;

        [WOA_fmin,WOA_bestX,WOA_curve]=WOA(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        WOA_fmins(i) = WOA_fmin;
        WOA_curves(i,:) = WOA_curve;

        [SSA_fmin,SSA_bestX,SSA_curve]=SSA(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        SSA_fmins(i) = SSA_fmin;
        SSA_curves(i,:) = SSA_curve;

        [AOA_fmin,AOA_bestX,AOA_curve]=AOA(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        AOA_fmins(i) = AOA_fmin;
        AOA_curves(i,:) = AOA_curve;

        [SCAAOA_fmin,SCAAOA_bestX,SCAAOA_curve]=SCAAOA(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        SCAAOA_fmins(i) = SCAAOA_fmin;
        SCAAOA_curves(i,:) = SCAAOA_curve;

        fprintf('\b\b%d',i);
    end

    %绘制结果
    subplot(1,3,k);
    %  axis([-inf,inf,1e-320,1e+5]);
    temp = [1,50,100,150,200,250,300,350,400,450,500];
    
    PSO1 = mean(PSO_curves);
    GWO1 = mean(GWO_curves);
    WOA1 = mean(WOA_curves); 
    SSA1 = mean(SSA_curves);
    AOA1 = mean(AOA_curves);
    SCAAOA1 = mean(SCAAOA_curves);
    
    
    Iteration = 1:M_Iter;
    semilogy(Iteration(temp),PSO1(temp),'-+k',Iteration(temp),GWO1(temp),'-*k',...
        Iteration(temp),WOA1(temp),'-xk',Iteration(temp),SSA1(temp),'-sk',...
        Iteration(temp),AOA1(temp),'-^k',Iteration,SCAAOA1,'k','LineWidth',1.5)


    % title('Convergence curve')
    xlabel('迭代次数');
    ylabel('适应度值');
    axis tight
    legend('PSO','GWO','WOA','SSA','AOA','SCAAOA');
    axis square;
end

%打印结果

% fprintf('\n');
% fprintf('目标函数：%s\n',F_name);
% fprintf('测试次数：%d\n',test_iteration);
% 
% fprintf('\n');
% fprintf('PSO求得平均值为:%.2E\n',mean(PSO_fmins));
% fprintf('PSO求得标准差为:%.2E\n',std(PSO_fmins));
% 
% fprintf('\n');
% fprintf('GWO求得平均值为:%.2E\n',mean(GWO_fmins));
% fprintf('GWO求得标准差为:%.2E\n',std(GWO_fmins));
% 
% fprintf('\n');
% fprintf('WOA求得平均值为:%.2E\n',mean(WOA_fmins));
% fprintf('WOA求得标准差为:%.2E\n',std(WOA_fmins));
% 
% fprintf('\n');
% fprintf('SSA求得平均值为:%.2E\n',mean(SSA_fmins));
% fprintf('SSA求得标准差为:%.2E\n',std(SSA_fmins));
% 
% fprintf('\n');
% fprintf('AOA求得平均值为:%.2E\n',mean(AOA_fmins));
% fprintf('AOA求得标准差为:%.2E\n',std(AOA_fmins));
% 
% fprintf('\n');
% fprintf('SCAAOA求得平均值为:%.2E\n',mean(SCAAOA_fmins));
% fprintf('SCAAOA求得标准差为:%.2E\n',std(SCAAOA_fmins));


