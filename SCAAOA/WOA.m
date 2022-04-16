% The Whale Optimization Algorithm
function [Leader_score,Leader_pos,Convergence_curve]=WOA(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

% initialize position vector and score for the leader，初始化位置向量和领导者得分
Leader_pos=zeros(1,dim);
Leader_score=inf; %change this to -inf for maximization problems，将此更改为-inf以获得最大化问题，Inf无穷大


%Initialize the positions of search agents
Positions=initializationWOA(SearchAgents_no,dim,ub,lb);%Positions，存放数个个体的多维位置。

Convergence_curve=zeros(1,Max_iter);%Convergence_curve收敛曲线

t=0;% Loop counter

% Main loop
while t<Max_iter
    for i=1:size(Positions,1)%对每个个体一个一个检查是否越界
        
        % Return back the search agents that go beyond the boundaries of
        % the search space，返回超出搜索空间边界的搜索代理
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;%超过最大值的设置成最大值，超过最小值的设置成最小值
        
        % Calculate objective function for each search agent，目标函数值的计算
        fitness=fobj(Positions(i,:));
        
        % Update the leader
        if fitness<Leader_score % Change this to > for maximization problem
            Leader_score=fitness; % Update alpha
            Leader_pos=Positions(i,:);
        end
        
    end
    
    a=2-t*((2)/Max_iter); % a decreases linearly fron 2 to 0 in Eq. (2.3)
    
    % a2 linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)，有疑问？
    a2=-1+t*((-1)/Max_iter);
    
    % Update the Position of search agents，参数更新 
    for i=1:size(Positions,1)
        r1=rand(); % r1 is a random number in [0,1]
        r2=rand(); % r2 is a random number in [0,1]
        
        A=2*a*r1-a;  % Eq. (2.3) in the paper
        C=2*r2;      % Eq. (2.4) in the paper
        
        
        b=1;               %  parameters in Eq. (2.5)
        l=(a2-1)*rand+1;   %  parameters in Eq. (2.5)
        
        p = rand();        % p in Eq. (2.6)
        
        for j=1:size(Positions,2)%对每一个个体地多维度进行循环运算
            
            if p<0.5%收缩包围机制 
                if abs(A)>=1
                    rand_leader_index = floor(SearchAgents_no*rand()+1);%floor将 X 的每个元素四舍五入到小于或等于该元素的最接近整数
                    X_rand = Positions(rand_leader_index, :);
                    D_X_rand=abs(C*X_rand(j)-Positions(i,j)); % Eq. (2.7)
                    Positions(i,j)=X_rand(j)-A*D_X_rand;      % Eq. (2.8)
                    
                elseif abs(A)<1
                    D_Leader=abs(C*Leader_pos(j)-Positions(i,j)); % Eq. (2.1)
                    Positions(i,j)=Leader_pos(j)-A*D_Leader;      % Eq. (2.2)
                end
                
            elseif p>=0.5%螺旋更新位置
              
                distance2Leader=abs(Leader_pos(j)-Positions(i,j));
                % Eq. (2.5)
                Positions(i,j)=distance2Leader*exp(b.*l).*cos(l.*2*pi)+Leader_pos(j);
                
            end
            
        end
    end
    t=t+1;
    Convergence_curve(t)=Leader_score;
%     [t Leader_score]
end

%此函数用于WOA初始化种群
function Positions=initializationWOA(SearchAgents_no,dim,ub,lb)

Boundary_no= size(ub,2); % numnber of boundaries，计算出第二个维度的大小

% If the boundaries of all variables are equal and user enter a signle
% number for both ub and lb
if Boundary_no==1
    Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;%产生范围内的随机数
end

% If each variable has a different lb and ub
if Boundary_no>1
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
        Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;%产生范围内的随机数
    end
end



