function [fMin, bestX, Convergence_curve] = SSA(pop,M,lb,ub,dim,fobj)

%初始化参数
P_producers = 0.2;    %发现者在种群中所占的比例
P_guards = 0.1;     %警戒者在种群中所占的比例
pNum_producers = round( pop *  P_producers );    % 发现者数量
pNum_guards = round( pop *  P_guards );     % 警戒者数量

%种群初始化
lb= lb.*ones( 1,dim );    % 下限
ub= ub.*ones( 1,dim );    % 上限
x = zeros(pop,dim);
fit =zeros(pop,1);
for i = 1 : pop
    x( i, : ) = lb + (ub - lb) .* rand( 1, dim );
    fit( i ) = fobj( x( i, : ) );
end

%麻雀个体历史最优位置及相应适应度值
pFit = fit;
pX = x;         

%找到初始最优麻雀个体和最差麻雀个体
[ fMin, bestI ] = min( fit );    
bestX = x( bestI, : );    

[fMax,worstI]=max( fit );
worstX= x(worstI,:);

% 开始迭代寻优
Convergence_curve = ones(1,M);
for t = 1 : M
         
    [ ~, sortIndex ] = sort( pFit );% 依据适应度排序  
           
    % 更新发现者位置
    r2=rand(1);
    if(r2<0.8)
        %周围没有捕食者
        for i = 1 : pNum_producers                                                % Equation (3)
            r1=rand(1);
            x( sortIndex( i ), : ) = pX( sortIndex( i ), : )*exp(-(i)/(r1*M));
            x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );%边界处理
            fit( sortIndex( i ) ) = fobj( x( sortIndex( i ), : ) );
        end      
    else
        %周围有捕食者
        for i = 1 : pNum_producers      
            x( sortIndex( i ), : ) = pX( sortIndex( i ), : )+randn(1)*ones(1,dim);
            x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );
            fit( sortIndex( i ) ) = fobj( x( sortIndex( i ), : ) );           
        end        
    end
      
    [ ~, bestII ] = min( fit );
    bestXX = x( bestII, : );%当前发现者所占据的最优位置
    
    % 更新加入者位置
    for i = ( pNum_producers + 1 ) : pop                     % Equation (4)
        
        A=floor(rand(1,dim)*2)*2-1;%1*dim的行向量，元素随机取1或-1；
        
        if( i>(pop/2))
            x( sortIndex(i ), : )=randn(1)*exp((worstX-pX( sortIndex( i ), : ))/(i)^2);
        else
            x( sortIndex( i ), : )=bestXX+(abs(( pX( sortIndex( i ), : )-bestXX)))*(A'*(A*A')^(-1))*ones(1,dim);        
        end
        
        x( sortIndex( i ), : ) = Bounds( x( sortIndex( i ), : ), lb, ub );%边界处理
        fit( sortIndex( i ) ) = fobj( x( sortIndex( i ), : ) );      
    end
      
    % 更新警戒者位置
    c=randperm(numel(sortIndex));
    b=sortIndex(c(1:pNum_guards));%在当前种群中随机挑选一部分麻雀作为警戒者
    
    for j = 1:length(b)      % Equation (5)
        
        if( pFit( sortIndex( b(j) ) )>(fMin) )  
            %警戒者位于种群边缘
            x( sortIndex( b(j) ), : )=bestX+randn(1).*(abs(( pX( sortIndex( b(j) ), : ) -bestX)));
        else  
             %警戒者位于种群中心
            x( sortIndex( b(j) ), : ) =pX( sortIndex( b(j) ), : )+(2*rand(1)-1)*(abs(pX( sortIndex( b(j) ), : )-worstX))/ ( pFit( sortIndex( b(j) ) )-fMax+1e-50);    
        end
        
        x( sortIndex(b(j) ), : ) = Bounds( x( sortIndex(b(j) ), : ), lb, ub );%边界处理    
        fit( sortIndex( b(j) ) ) = fobj( x( sortIndex( b(j) ), : ) );
        
    end
    
    % 评估每只麻雀的新位置，若更优则进行替换
    for i = 1 : pop
        
        if ( fit( i ) < pFit( i ) )
            pFit( i ) = fit( i );
            pX( i, : ) = x( i, : );
        end
          
    end
    
    %更新当前种群最优麻雀个体和最差麻雀个体
    [ fMin, bestI ] = min( pFit );
    bestX = x( bestI, : );
    
    [fMax,worstI]=max( pFit );
    worstX= x(worstI,:);
      
    % 记录每代最优适应度值
    Convergence_curve(t)=fMin;
    
end
end

% 边界处理函数
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
