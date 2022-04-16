% The Whale Optimization Algorithm
function [Leader_score,Leader_pos,Convergence_curve]=WOA(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

% initialize position vector and score for the leader����ʼ��λ���������쵼�ߵ÷�
Leader_pos=zeros(1,dim);
Leader_score=inf; %change this to -inf for maximization problems�����˸���Ϊ-inf�Ի��������⣬Inf�����


%Initialize the positions of search agents
Positions=initializationWOA(SearchAgents_no,dim,ub,lb);%Positions�������������Ķ�άλ�á�

Convergence_curve=zeros(1,Max_iter);%Convergence_curve��������

t=0;% Loop counter

% Main loop
while t<Max_iter
    for i=1:size(Positions,1)%��ÿ������һ��һ������Ƿ�Խ��
        
        % Return back the search agents that go beyond the boundaries of
        % the search space�����س��������ռ�߽����������
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;%�������ֵ�����ó����ֵ��������Сֵ�����ó���Сֵ
        
        % Calculate objective function for each search agent��Ŀ�꺯��ֵ�ļ���
        fitness=fobj(Positions(i,:));
        
        % Update the leader
        if fitness<Leader_score % Change this to > for maximization problem
            Leader_score=fitness; % Update alpha
            Leader_pos=Positions(i,:);
        end
        
    end
    
    a=2-t*((2)/Max_iter); % a decreases linearly fron 2 to 0 in Eq. (2.3)
    
    % a2 linearly dicreases from -1 to -2 to calculate t in Eq. (3.12)�������ʣ�
    a2=-1+t*((-1)/Max_iter);
    
    % Update the Position of search agents���������� 
    for i=1:size(Positions,1)
        r1=rand(); % r1 is a random number in [0,1]
        r2=rand(); % r2 is a random number in [0,1]
        
        A=2*a*r1-a;  % Eq. (2.3) in the paper
        C=2*r2;      % Eq. (2.4) in the paper
        
        
        b=1;               %  parameters in Eq. (2.5)
        l=(a2-1)*rand+1;   %  parameters in Eq. (2.5)
        
        p = rand();        % p in Eq. (2.6)
        
        for j=1:size(Positions,2)%��ÿһ������ض�ά�Ƚ���ѭ������
            
            if p<0.5%������Χ���� 
                if abs(A)>=1
                    rand_leader_index = floor(SearchAgents_no*rand()+1);%floor�� X ��ÿ��Ԫ���������뵽С�ڻ���ڸ�Ԫ�ص���ӽ�����
                    X_rand = Positions(rand_leader_index, :);
                    D_X_rand=abs(C*X_rand(j)-Positions(i,j)); % Eq. (2.7)
                    Positions(i,j)=X_rand(j)-A*D_X_rand;      % Eq. (2.8)
                    
                elseif abs(A)<1
                    D_Leader=abs(C*Leader_pos(j)-Positions(i,j)); % Eq. (2.1)
                    Positions(i,j)=Leader_pos(j)-A*D_Leader;      % Eq. (2.2)
                end
                
            elseif p>=0.5%��������λ��
              
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

%�˺�������WOA��ʼ����Ⱥ
function Positions=initializationWOA(SearchAgents_no,dim,ub,lb)

Boundary_no= size(ub,2); % numnber of boundaries��������ڶ���ά�ȵĴ�С

% If the boundaries of all variables are equal and user enter a signle
% number for both ub and lb
if Boundary_no==1
    Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;%������Χ�ڵ������
end

% If each variable has a different lb and ub
if Boundary_no>1
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
        Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;%������Χ�ڵ������
    end
end



