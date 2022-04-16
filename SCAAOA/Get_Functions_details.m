function [lb,ub,dim,fobj] = Get_Functions_details(F)

% lb是下界,ub是上界,dim是维数,fobj是目标函数

dim = 30;

switch F
    
    case 'F1'
        fobj = @F1;
        lb=-100;
        ub=100;
        
    case 'F2'
        fobj = @F2;
        lb=-100;
        ub=100;
        
    case 'F3'
        fobj = @F3;
        lb=-100;
        ub=100;
        
    case 'F4'
        fobj = @F4;
        lb=-10;
        ub=10;
              
    case 'F5'
        fobj = @F5;
        lb=-10;
        ub=10;     
        
     case 'F6'
        fobj = @F6;
        lb=-5;
        ub=10; 
        
    case 'F7'
        fobj = @F7;
        lb=-1.28;
        ub=1.28;
        
    case 'F8'
        fobj = @F8;
        lb=-100;
        ub=100;
        
    case 'F9'
        fobj = @F9;
        lb=-5.12;
        ub=5.12;
     
    case 'F10'
        fobj = @F10;
        lb=-600;
        ub=600;
        
    case 'F11'
        fobj = @F11;
        lb=-32;
        ub=32;
        
    case 'F12'
        fobj = @F12;
        lb=-10;
        ub=10;
        
    case 'F13'
        fobj = @F13;
        lb=-100;
        ub=100;
        
    case 'F14'
        fobj = @F14;
        lb=-100;
        ub=100;
          
end
end

%% Sphere 单峰，最优解为0，分布在X=[0,0,...,0]处
function o = F1(x)
o=sum(x.^2);
end

%% Schwefe1.2 单峰，最优解为0，分布在X=[0,0,...,0]处
function o = F2(x)
o = 0;
for i = 1:length(x)
    o = o + sum(x(1:i))^2;
end
end

%% Schwefel 2.21 单峰，最优解为0，分布在X=[0,0,...,0]处
function o = F3(x)
o = max(abs(x));
end

%% Schwefel 2.22 单峰，最优解为0，分布在X=[0,0,...,0]处
function o = F4(x)
o=sum(abs(x))+prod(abs(x));
end

%% Sum squares 单峰，最优解为0，分布在X=[0,0,...,0]处
function o = F5(x)
o=sum((1:length(x)).*(x.^2));
end


%% Zakharov 单峰，最优解为0，分布在X=[0,0,...,0]处
function o = F6(x)
% o=sum(x.^2) + sum(0.5*(1:length(x)).*x)^2 + sum(0.5*(1:length(x)).*x)^4;
o=sum(x.^2) + sum(0.5*x)^2 + sum(0.5*x)^4;
end

%% Quartic 单峰
function o = F7(x)
dim=size(x,2);
o = 0;
for i = 1:dim
    o = o+i*x(i)^4;
end
o = o+rand;
end

%% High Conditioned Elliptic 单峰，最优解为0，分布在X=[0,0,...,0]处
function o = F8(x)
D = length(x);
temp = 0:D-1;
o = sum((10^6).^(temp/(D-1)).*x.^2);
end

%% Rastrigin's 多峰，最优解为0，分布在X=[0,0,...,0]处
function o = F9(x)
o=sum(x.^2-10*cos(2*pi*x)+10);
end

%% Griewank's 多峰，最优解为0，分布在X=[0,0,...,0]处
function o = F10(x)
temp = 1:length(x);
o = sum(x.^2)/4000 - prod(cos(x./sqrt(temp))) + 1;
end

%% Ackley's 多峰，最优解为0，分布在X=[0,0,...,0]处
function o = F11(x)
o = -20*exp(-0.2*sqrt(mean(x.^2))) + 20 + exp(1) - exp(mean(cos(2*pi*x)));
end

%% Alpine 多峰，最优解为0，分布在X=[0,0,...,0]处
function o = F12(x)
o = sum(abs(x.*sin(x)+0.1*x));
end


%% Schaffer's F7 多峰，最优解为0，分布在X=[0,0,...,0]处
function o = F13(x)
s = sqrt(x(1:end-1).^2+x(2:end).^2);
o = mean(sqrt(s).*(sin(50*s.^0.2)+1))^2;
end

%% Expanded Schaffer's F6 多峰，最优解为0，分布在X=[0,0,...,0]处
function o = g(x,y)
o = 0.5 + (sin(sqrt(x^2+y^2))^2-0.5)/(1+0.001*(x^2+y^2))^2;
end
function o = F14(x)
o = 0;
D = length(x);
for i = 1:(D-1)
    o = o + g(x(i),x(i+1));
end
o = o + g(x(D),x(1));
end

