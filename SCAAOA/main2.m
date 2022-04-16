%��ջ�������
clear;
close all;
clc;


Solution_no=30; %��Ⱥ��С
% F_name='F5';    %Ŀ�꺯���� 
M_Iter=500;     %����������
                                

for k = 1:3   %��������ͼ��ÿ�����в���3��������
    
    F_name=k;    %Ŀ�꺯�������˴���Get_Functions_details�е���Ӧ��������Ϊ���ּ��ɵ��ã�
    [LB,UB,Dim,F_obj]=Get_Functions_details(F_name); %��ȡĿ�꺯��

    %�����㷨��30�Σ�
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

    %���ƽ��
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

    xlabel('��������');
    ylabel('��Ӧ��ֵ');
    axis tight
    legend('AOA','AOA1','AOA2','IAOA','HSMAAOA','SCAAOA');
    % legend('AOA','IAOA','SCAAOA');
    axis square;
end

% %��ӡ���
% 
% fprintf('\n');
% fprintf('Ŀ�꺯����%s',F_name);
% 
% fprintf('\n');
% fprintf('AOA���ƽ��ֵΪ:%.2E\n',mean(AOA_fmins));
% fprintf('AOA��ñ�׼��Ϊ:%.2E\n',std(AOA_fmins));
% 
% fprintf('\n');
% fprintf('AOA1���ƽ��ֵΪ:%.2E\n',mean(AOA1_fmins));
% fprintf('AOA1��ñ�׼��Ϊ:%.2E\n',std(AOA1_fmins));
% 
% fprintf('\n');
% fprintf('AOA2���ƽ��ֵΪ:%.2E\n',mean(AOA2_fmins));
% fprintf('AOA2��ñ�׼��Ϊ:%.2E\n',std(AOA2_fmins));
% 
% fprintf('\n');
% fprintf('IAOA���ƽ��ֵΪ:%.2E\n',mean(IAOA_fmins));
% fprintf('IAOA��ñ�׼��Ϊ:%.2E\n',std(IAOA_fmins))
% 
% fprintf('\n');
% fprintf('HSMAAOA���ƽ��ֵΪ:%.2E\n',mean(HSMAAOA_fmins));
% fprintf('HSMAAOA��ñ�׼��Ϊ:%.2E\n',std(HSMAAOA_fmins));
% 
% 
% fprintf('\n');
% fprintf('SCAAOA���ƽ��ֵΪ:%.2E\n',mean(SCAAOA_fmins));
% fprintf('SCAAOA��ñ�׼��Ϊ:%.2E\n',std(SCAAOA_fmins));


