function SGA
% -------- 共性参数 ---------
NP = 50;         % 种群规模
Max_N = 10000;   % 限定代数
Pc = 0.80;       % 交叉概率
Pm = 0.01;       % 变异概率

% -------- 个性参数 ----------
D = 30;          % 种群维度
MinX = -100;     % 候选解空间最小值
MaxX = 100;      % 候选解空间最大值
Error = 1.0e-10; % 允许的错误率

% -------- 初始化 ----------
X = MinX + (MaxX - MinX) * rand(NP,D);
F = fun1(X);
[bestF, bestlow] = min(F);  % 获得最小值和最小值索引
bestX = X(bestlow,:);       % 存储获得最优解的X输入数据

% -------- 优化开始 ----------
for gen = 1:1:Max_N
    time(gen) = gen;
    % -------- 复制操作 ----------
    tempF = cumsum(1 ./ F / sum(1 ./F ));  % 获得累加和
    CX = X;
    for i = 1:1:NP
        rnd = rand;
        for flag = 1:1:NP
            if rnd < tempF(flag)
                X(i,:) = CX(flag, :);
                break;
            end
        end
    end
    X(NP,:) = bestX;
    % -------- 种群交叉 ----------
    Pc_rand = rand(1, NP);
    for i = 1:2:(NP-1)
        if Pc_rand(i) < Pc
            alfa = rand;
            X(i, :) = alfa * X(i+1, :) + (1 - alfa) * X(i, :);
            X(i+1,:) = alfa * X(i, :) + (1 - alfa) * X(i+1, :);
        end
    end
    % -------- 种群变异 ----------
    Pm_rand = rand(NP,D);
    for i = 1:1:NP
        for j = 1:1:D
            if Pm_rand(i,j) < Pm
                X(i,j) = MinX + (MaxX - MinX) * rand;
            end
        end
    end
    X(NP,:) = bestX;
    % -------- 算函数值 ----------
    F = fun1(X);
    % -------- 种群评估 ----------
    [bestF, bestlow] = min(F);
    bestX = X(bestlow, :);
    % -------- 记录结果 ----------
    result(gen) = bestF;
    if bestF < Error
        break;
    end
    if mod(gen, 100) == 0
        disp(['代数：', num2str(gen), '----最优：', num2str(bestF)]);
    end
end
plot(time, result)
% -------- 子函数1：目标函数 ----------
function f1 = fun1(X)
for i = 1:1:length(X(:,1))
    f1(i) = sum(X(i,:) .^ 2);
end
    