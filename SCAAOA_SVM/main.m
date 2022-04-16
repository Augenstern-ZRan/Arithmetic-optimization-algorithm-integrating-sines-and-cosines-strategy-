%% ���������㷨�Ż���SVM�����㷨��

%% ��ջ�������
close all;
clear;
clc;

%% ������ȡ

% ѵ����
Training_Data = xlsread('zhishi.xls','Training_Data','A2:F259');
train = Training_Data(:,1:end-1);
train_labels = Training_Data(:,end);

% ���Լ�
Test_Data = xlsread('zhishi.xls','Test_Data','A2:F146');
test = Test_Data(:,1:end-1);
test_labels = Test_Data(:,end);

%% ����Ԥ����
% ����Ԥ����,��ѵ�����Ͳ��Լ���һ����[0,1]����

[mtrain,ntrain] = size(train);
[mtest,ntest] = size(test);

dataset = [train;test];

% mapminmaxΪMATLAB�Դ��Ĺ�һ������
[dataset_scale,ps] = mapminmax(dataset',0,1);
dataset_scale = dataset_scale';

train = dataset_scale(1:mtrain,:);
test = dataset_scale( (mtrain+1):(mtrain+mtest),: );

%% �����㷨�Ż�SVM����
tic
%%  �Ż��㷨��������
% �����Ż������ĸ������ڸó����У��Ż������ĸ���dimΪ2 ��
% �����Ż������������ޣ���c�ķ�Χ��[0.01, 1]�� g�ķ�Χ��[2^-5, 2^5]����ô����������lb=[0.01, 2^-5]������������ub=[1, 2^5]��
%Ŀ�꺯��
fun = @getObjValue; 
% �Ż������ĸ��� (c��g)
dim = 2;
% �Ż�������ȡֵ����
% lb = [0.01, 0.01];
% ub = [1000, 1000];

lb=0.01;
ub = 1000;

%%  ��������
pop =30; %��Ⱥ����
Max_iteration=50;%����������     

%% �Ż�(������Ҫ���ú���)
[Best_score,Best_pos,curve]=AOA(pop,Max_iteration,lb,ub,dim,fun); 
c = Best_pos(1, 1);  
g = Best_pos(1, 2); 
toc
% ���Ż��õ�c,gѵ���Ͳ���
cmd = ['-s 0 -t 2 ', '-c ', num2str(c), ' -g ', num2str(g), ' -q'];
model = libsvmtrain(train_labels, train, cmd);

%% SVM����Ԥ��
[predict_label, accuracy,decision_values] = libsvmpredict(test_labels, test, model);
%% �������
figure;
hold on;
plot(test_labels,'o');
plot(predict_label,'r*');
xlabel('���Լ�����','FontSize',12);
ylabel('����ǩ','FontSize',12);
legend('ʵ�ʲ��Լ�����','Ԥ����Լ�����');
% title('���Լ���ʵ�ʷ����Ԥ�����ͼ','FontSize',12);
title(['����Ԥ��׼ȷ�ʣ�',num2str(accuracy(1)),'%']);
grid on;
disp(['����Ԥ��׼ȷ�ʣ�',num2str(accuracy(1))])