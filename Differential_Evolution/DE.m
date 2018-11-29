function DE
% --------参数设置 ---------
NP = 100;       % 种群规模
D = 10;         % 变量个数
MinX = -30;     % 范围下限
MaxX = 30;      % 范围上限
alpha = 0.6;    % 缩放因子
beta = 0.6;     % 缩放因子
CR = 0.8;       % 交叉概率
Error = 1.0;    % 限定精度
Max_N = 1000;   % 限定代数

% -------- 位置初始化 --------
for i = 1:1:D
    X(:,i) = MinX + (MaxX - MinX) * rand(NP,1);
    selfX(:,i) = X(:,i);
end
% -------- 计算函数值 --------
F = fun(X);
selfF = F;
% -------- 求最优解 --------
[Bestf,Indexf] = sort(F,2);   % 对NP个函数值排序
Bestfi = Bestf(1);            % 第一个函数值最小
Bestp = Indexf(1);            % 最优粒子序号

% ----------------- 程序主循环开始 -------------------------
for gen = 1:1:Max_N
    time(gen) = gen;
    % ---------- 变异操作 --------
    for i= 1:1:NP
        flag1 = ceil(rand * NP); % 取一个随机整数
        while(flag1 == i)
            flag1 = ceil(rand * NP);
        end
        flag2 = ceil(rand * NP);
        while(flag2 == i) | (flag2 == flag1)
            flag2 = ceil(rand * NP);
        end
        X(i,:) = X(i,:) + alpha * (X(Bestp,:) - X(i,:))...
            + beta * (X(flag1,:) - X(flag2,:));
    end
    % --------- 交叉操作 ---------
    for i = 1:1:NP
        temp = rand(1,D);
        for j = 1:1:D
            if temp(j) > CR
                X(i,j) = selfX(i,j);
            end
        end
    end
    % --------- 计算函数值 --------
    F = fun(X);
    % --------- 选择操作 ---------
    for i = 1:1:NP
        if F(i) >= selfF(i)
            F(i) = selfF(i);
            X(i,:) = selfX(i,:);
        end
    end
    % -------- 迭代更新 ---------
    for i = 1:1:NP
        selfF(i) = F(i);
        selfX(i,:) = X(i,:);
    end
    % -------- 求最优解 --------
    [Bestf, Indexf] = sort(F,2); % 对NP个函数值排序
    Bestfi = Bestf(1);
    Bestp = Indexf(1);
    % -------记录结果 ---------
    result(gen) = Bestfi;
    if mod(gen,10) == 0
        disp(sprintf('代数：%d -------- 结果：%f',gen,Bestfi));
        plot(time,result,'r');axis([1,Max_N, 0, 100]);
        xlabel('迭代步数');ylabel('优化结果');
        drawnow;pause(0.1);
    end
    if Bestfi < Error
        break;
    end
end
disp('');
disp(sprintf('迭代步数：%d ------- 优化结果：%f',gen,Bestfi));
% ---- 子函数:目标函数 ----
function F = fun(X)
for i = 1:1:size(X,1)
    for j = 1:1:size(X,2)
        x(j) = X(i,j);
    end
    for j = 1:1:size(X,2) - 1
        temp(j) = 100 * (x(j+1)-x(j)^2)^2 + (x(j)-1)^2;
    end
    F(i) = sum(temp);
end
            