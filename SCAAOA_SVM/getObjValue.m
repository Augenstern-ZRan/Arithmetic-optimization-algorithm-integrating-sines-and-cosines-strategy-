function objValue = getObjValue(parameter)
% 目标函数是一个非显式过程，唯一的传参是参数（或参数向量），输出参数为目标函数的值，
% 由于学生知识水平预测是一个多分类任务，采用最大化准确率（最小化错误率）的目标函数。
% 由于在训练过程中需要读取训练数据以及对应的标签，因此在目标函数内部读取数据，有三种方式：
% 
% （1）定义训练数据和标签的全局变量
% （2）利用load函数读取训练数据和标签
% （3）利用evalin函数读取主函数空间的训练数据和标签

    % 训练数据
   
    data = evalin('base', 'train');
    label = evalin('base', 'train_labels');
    
    % 判断是否需要 K 折交叉验证
    kfolds_ = evalin('base', 'kfolds');

    c = parameter(1, 1);
    g = parameter(1, 2);

   switch ~isempty(kfolds_)

        case 1
        cmd = ['-s 0 -t 2 ', '-c ', num2str(c), ' -g ', num2str(g),...
            ' -v ', num2str(kfolds_), ' -q'];
        acc = svmtrain(label, data, cmd);

        case 0
        cmd = ['-s 0 -t 2 ', '-c ', num2str(c), ' -g ', num2str(g), ' -q'];
        model = svmtrain(label, data, cmd);
        [~, acc_, ~] = svmpredict(label, data, model);
        acc = acc_(1);
    end
    
    objValue=1-acc(1)/100; % 以分类预测错误率作为优化的目标函数值
    end
end

