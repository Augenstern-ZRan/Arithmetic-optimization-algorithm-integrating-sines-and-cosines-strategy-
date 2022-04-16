%清空环境变量
clear;
close all;
clc;


Solution_no=30; %种群大小
% F_name='F5';    %目标函数名 
M_Iter=500;     %最大迭代次数
                                

for k = 1:3   %（用于作图，每次运行测试3个函数）
    
    F_name=k;    %目标函数名（此处将Get_Functions_details中的相应函数名改为数字即可调用）
    [LB,UB,Dim,F_obj]=Get_Functions_details(F_name); %获取目标函数

    %运行算法（30次）
    test_iteration = 30;

    AOA_fmins = zeros(1,test_iteration);
    AOA_curves = zeros(test_iteration,M_Iter);

    AOA1_fmins = zeros(1,test_iteration);
    AOA1_curves = zeros(test_iteration,M_Iter);

    AOA2_fmins = zeros(1,test_iteration);
    AOA2_curves = zeros(test_iteration,M_Iter);

    IAOA_fmins = zeros(1,test_iteration);
    IAOA_curves = zeros(test_iteration,M_Iter);

    HSMAAOA_fmins = zeros(1,test_iteration);
    HSMAAOA_curves = zeros(test_iteration,M_Iter);

    SCAAOA_fmins = zeros(1,test_iteration);
    SCAAOA_curves = zeros(test_iteration,M_Iter);

    for i = 1:test_iteration

        [AOA_fmin,AOA_bestX,AOA_curve]=AOA(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        AOA_fmins(i) = AOA_fmin;
        AOA_curves(i,:) = AOA_curve;

        [AOA1_fmin,AOA1_bestX,AOA1_curve]=AOA1(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        AOA1_fmins(i) = AOA1_fmin;
        AOA1_curves(i,:) = AOA1_curve;

        [AOA2_fmin,AOA2_bestX,AOA2_curve]=AOA2(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        AOA2_fmins(i) = AOA2_fmin;
        AOA2_curves(i,:) = AOA2_curve;

        [IAOA_fmin,IAOA_bestX,IAOA_curve]=IAOA(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        IAOA_fmins(i) =IAOA_fmin;
        IAOA_curves(i,:) = IAOA_curve;

        [HSMAAOA_fmin,HSMAAOA_bestX,HSMAAOA_curve]=HSMAAOA(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        HSMAAOA_fmins(i) = HSMAAOA_fmin;
        HSMAAOA_curves(i,:) = HSMAAOA_curve;

        [SCAAOA_fmin,SCAAOA_bestX,SCAAOA_curve]=SCAAOA(Solution_no,M_Iter,LB,UB,Dim,F_obj);
        SCAAOA_fmins(i) = SCAAOA_fmin;
        SCAAOA_curves(i,:) = SCAAOA_curve;

        fprintf('\b\b%d',i);
    end

    %绘制结果
    subplot(1,3,k);
    %  axis([-inf,inf,1e-320,1e+5]);
    Iteration = 1:M_Iter;
    
    AOA_t = mean(AOA_curves);
    AOA1_t = mean(AOA1_curves);
    AOA2_t = mean(AOA2_curves);
    IAOA_t = mean(IAOA_curves);
    HSMAAOA_t = mean(HSMAAOA_curves);
    SCAAOA_t = mean(SCAAOA_curves);
    temp = [1,50,100,150,200,250,300,350,400,450,500];
    temp1 = [1,25,50,100,150,200,250,300,350,400,450,500];
    
   
    semilogy(Iteration(temp),AOA_t(temp),'-+k'...
        ,Iteration(temp),AOA1_t(temp),'-*k'...
        ,Iteration(temp),AOA2_t(temp),'-xk'...
        ,Iteration(temp),IAOA_t(temp),'-sk'...
        ,Iteration(temp),HSMAAOA_t(temp),'-^k'...
        ,Iteration,SCAAOA_t,'k','LineWidth',1.5)

% semilogy(Iteration,mean(AOA_curves),'r'...
%     ,Iteration,mean(IAOA_curves),'g'...
%     ,Iteration,mean(SCAAOA_curves),'b','LineWidth',2)

%     title('Convergence curve')

    xlabel('迭代次数');
    ylabel('适应度值');
    axis tight
    legend('AOA','AOA1','AOA2','IAOA','HSMAAOA','SCAAOA');
    % legend('AOA','IAOA','SCAAOA');
    axis square;
end

% %打印结果
% 
% fprintf('\n');
% fprintf('目标函数：%s',F_name);
% 
% fprintf('\n');
% fprintf('AOA求得平均值为:%.2E\n',mean(AOA_fmins));
% fprintf('AOA求得标准差为:%.2E\n',std(AOA_fmins));
% 
% fprintf('\n');
% fprintf('AOA1求得平均值为:%.2E\n',mean(AOA1_fmins));
% fprintf('AOA1求得标准差为:%.2E\n',std(AOA1_fmins));
% 
% fprintf('\n');
% fprintf('AOA2求得平均值为:%.2E\n',mean(AOA2_fmins));
% fprintf('AOA2求得标准差为:%.2E\n',std(AOA2_fmins));
% 
% fprintf('\n');
% fprintf('IAOA求得平均值为:%.2E\n',mean(IAOA_fmins));
% fprintf('IAOA求得标准差为:%.2E\n',std(IAOA_fmins))
% 
% fprintf('\n');
% fprintf('HSMAAOA求得平均值为:%.2E\n',mean(HSMAAOA_fmins));
% fprintf('HSMAAOA求得标准差为:%.2E\n',std(HSMAAOA_fmins));
% 
% 
% fprintf('\n');
% fprintf('SCAAOA求得平均值为:%.2E\n',mean(SCAAOA_fmins));
% fprintf('SCAAOA求得标准差为:%.2E\n',std(SCAAOA_fmins));


