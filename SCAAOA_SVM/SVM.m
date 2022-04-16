%% SVM分类算法。

%% 清空环境变量
close all;
clear;
clc;

%% 数据提取

% 训练集
Training_Data = xlsread('zhishi.xls','Training_Data','A2:F259');
train = Training_Data(1:end,1:end-1);
train_labels = Training_Data(:,end);

% 测试集
Test_Data = xlsread('zhishi.xls','Test_Data','A2:F146');
test = Test_Data(1:end,1:end-1);
test_labels = Test_Data(:,end);

%% 数据预处理
% 数据预处理,将训练集和测试集归一化到[0,1]区间

[mtrain,ntrain] = size(train);
[mtest,ntest] = size(test);

dataset = [train;test];
% mapminmax为MATLAB自带的归一化函数
[dataset_scale,ps] = mapminmax(dataset',0,1);
dataset_scale = dataset_scale';

train = dataset_scale(1:mtrain,:);
test = dataset_scale( (mtrain+1):(mtrain+mtest),: );

%% SVM网络训练
% model = svmtrain(train_wine_labels, train_wine, '-c 2 -g 1');
model = libsvmtrain(train_labels, train, '-c 2 -g 1');


%% SVM网络预测
% [predict_label, accuracy] = svmpredict(test_wine_labels, test_wine, model);
[predict_label, accuracy,decision_values] = svmpredict(test_labels, test, model);

%% 结果分析

figure;
hold on;
plot(test_labels,'o');
plot(predict_label,'r*');
xlabel('测试集样本','FontSize',12);
ylabel('类别标签','FontSize',12);
legend('实际测试集分类','预测测试集分类');
% title('测试集的实际分类和预测分类图','FontSize',12);
title(['最终预测准确率：',num2str(accuracy(1)),'%']);
grid on;