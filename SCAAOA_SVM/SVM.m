%% SVM�����㷨��

%% ��ջ�������
close all;
clear;
clc;

%% ������ȡ

% ѵ����
Training_Data = xlsread('zhishi.xls','Training_Data','A2:F259');
train = Training_Data(1:end,1:end-1);
train_labels = Training_Data(:,end);

% ���Լ�
Test_Data = xlsread('zhishi.xls','Test_Data','A2:F146');
test = Test_Data(1:end,1:end-1);
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

%% SVM����ѵ��
% model = svmtrain(train_wine_labels, train_wine, '-c 2 -g 1');
model = libsvmtrain(train_labels, train, '-c 2 -g 1');


%% SVM����Ԥ��
% [predict_label, accuracy] = svmpredict(test_wine_labels, test_wine, model);
[predict_label, accuracy,decision_values] = svmpredict(test_labels, test, model);

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