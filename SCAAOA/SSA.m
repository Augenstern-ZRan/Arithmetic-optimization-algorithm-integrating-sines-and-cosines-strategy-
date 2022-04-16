function [fMin, bestX, Convergence_curve] = SSA(pop,M,lb,ub,dim,fobj)

%��ʼ������
P_producers = 0.2;    %����������Ⱥ����ռ�ı���
P_guards = 0.1;     %����������Ⱥ����ռ�ı���
pNum_producers = round( pop *  P_producers );    % ����������
pNum_guards = round( pop *  P_guards );     % ����������

%��Ⱥ��ʼ��
lb= lb.*ones( 1,dim );    % ����
ub= ub.*ones( 1,dim );    % ����
x = zeros(pop,dim);
fit =zeros(pop,1);
for i = 1 : pop
    x( i, : ) = lb + (ub - lb) .* rand( 1, dim );
    fit( i ) = fobj( x( i, : ) );
end

%��ȸ������ʷ����λ�ü���Ӧ��Ӧ��ֵ
pFit = fit;
pX = x;         

%�ҵ���ʼ������ȸ����������ȸ����
[ fMin, bestI ] = min( fit );    
bestX = x( bestI, : );    

[fMax,worstI]=max( fit );
worstX= x(worstI,:);

% ��ʼ����Ѱ��
Convergence_curve = ones(1,M);
for t = 1 : M
         
    [ ~, sortIndex ] = sort( pFit );% ������Ӧ������  
           
    % ���·�����λ��
    r2=rand(1);
    if(r2<0.8)
        %��Χû�в�ʳ��
        for i = 1 : pNum_producers                                                % Equation (3)
            r1=rand(1);
            x( sortIndex( i ), : ) = pX( sortIndex( i ), : )*exp(-(i)/(r1*M));
            x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );%�߽紦��
            fit( sortIndex( i ) ) = fobj( x( sortIndex( i ), : ) );
        end      
    else
        %��Χ�в�ʳ��
        for i = 1 : pNum_producers      
            x( sortIndex( i ), : ) = pX( sortIndex( i ), : )+randn(1)*ones(1,dim);
            x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );
            fit( sortIndex( i ) ) = fobj( x( sortIndex( i ), : ) );           
        end        
    end
      
    [ ~, bestII ] = min( fit );
    bestXX = x( bestII, : );%��ǰ��������ռ�ݵ�����λ��
    
    % ���¼�����λ��
    for i = ( pNum_producers + 1 ) : pop                     % Equation (4)
        
        A=floor(rand(1,dim)*2)*2-1;%1*dim����������Ԫ�����ȡ1��-1��
        
        if( i>(pop/2))
            x( sortIndex(i ), : )=randn(1)*exp((worstX-pX( sortIndex( i ), : ))/(i)^2);
        else
            x( sortIndex( i ), : )=bestXX+(abs(( pX( sortIndex( i ), : )-bestXX)))*(A'*(A*A')^(-1))*ones(1,dim);        
        end
        
        x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );%�߽紦��
        fit( sortIndex( i ) ) = fobj( x( sortIndex( i ), : ) );      
    end
      
    % ���¾�����λ��
    c=randperm(numel(sortIndex));
    b=sortIndex(c(1:pNum_guards));%�ڵ�ǰ��Ⱥ�������ѡһ������ȸ��Ϊ������
    
    for j = 1:length(b)      % Equation (5)
        
        if( pFit( sortIndex( b(j) ) )>(fMin) )  
            %������λ����Ⱥ��Ե
            x( sortIndex( b(j) ), : )=bestX+randn(1).*(abs(( pX( sortIndex( b(j) ), : ) -bestX)));
        else  
             %������λ����Ⱥ����
            x( sortIndex( b(j) ), : ) =pX( sortIndex( b(j) ), : )+(2*rand(1)-1)*(abs(pX( sortIndex( b(j) ), : )-worstX))/ ( pFit( sortIndex( b(j) ) )-fMax+1e-50);    
        end
        
        x( sortIndex(b(j) ), : ) = Bounds( x( sortIndex(b(j) ), : ), lb, ub );%�߽紦��    
        fit( sortIndex( b(j) ) ) = fobj( x( sortIndex( b(j) ), : ) );
        
    end
    
    % ����ÿֻ��ȸ����λ�ã�������������滻
    for i = 1 : pop
        
        if ( fit( i ) < pFit( i ) )
            pFit( i ) = fit( i );
            pX( i, : ) = x( i, : );
        end
          
    end
    
    %���µ�ǰ��Ⱥ������ȸ����������ȸ����
    [ fMin, bestI ] = min( pFit );
    bestX = x( bestI, : );
    
    [fMax,worstI]=max( pFit );
    worstX= x(worstI,:);
      
    % ��¼ÿ��������Ӧ��ֵ
    Convergence_curve(t)=fMin;
    
end
end

% �߽紦����
function s = Bounds( s, Lb, Ub)
% Apply the lower bound vector
temp = s;   
I = temp < Lb;
temp(I) = Lb(I);

% Apply the upper bound vector
J = temp > Ub;
temp(J) = Ub(J);
% Update this new move
s = temp;
end
