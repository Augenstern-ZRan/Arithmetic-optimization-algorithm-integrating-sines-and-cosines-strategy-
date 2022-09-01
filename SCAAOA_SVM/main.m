%% 基于智能算法优化的SVM分类算法。

%% 清空环境变量
close all;
clear;
clc;

%% 数据提取

% 训练集
Training_Data = xlsread('zhishi.xls','Training_Data','A2:F259');
train = Training_Data(:,1:end-1);
train_labels = Training_Data(:,end);

% 测试集
Test_Data = xlsread('zhishi.xls','Test_Data','A2:F146');
test = Test_Data(:,1:end-1);
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

%% 智能算法优化SVM参数
tic
%%  优化算法参数设置
% 定义优化参数的个数，在该场景中，优化参数的个数dim为2 。
% 定义优化参数的上下限，如c的范围是[0.01, 1]， g的范围是[2^-5, 2^5]，那么参数的下限lb=[0.01, 2^-5]；参数的上限ub=[1, 2^5]。
%目标函数
fun = @getObjValue; 
% 优化参数的个数 (c、g)
dim = 2;
% 优化参数的取值下限
% lb = [0.01, 0.01];
% ub = [1000, 1000];

lb=0.01;
ub = 1000;

% 交叉验证参数设置（关闭交叉验证时设置为[]）
kfolds = 5;

%%  参数设置
pop =30; %种群数量
Max_iteration=50;%最大迭代次数    


%% 优化(这里主要调用函数)
[Best_score,Best_pos,curve]=AOA(pop,Max_iteration,lb,ub,dim,fun); 
c = Best_pos(1, 1);  
g = Best_pos(1, 2); 
toc
% 用优化得到c,g训练和测试
cmd = ['-s 0 -t 2 ', '-c ', num2str(c), ' -g ', num2str(g), ' -q'];
model = libsvmtrain(train_labels, train, cmd);

%% SVM网络预测
[predict_label, accuracy,decision_values] = libsvmpredict(test_labels, test, model);
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
disp(['最终预测准确率：',num2str(accuracy(1))])
