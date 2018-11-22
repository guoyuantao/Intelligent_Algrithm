function PSO
% ------------------- 共性参数 -------------------
NP = 20;     % 种群规模
D = 2;       % 变量个数
maxgen = 100;% 限定步数

% ------------------- 共性参数 -------------------
selfw = 2.0;        % 自身因子
globalw = 2.0;      % 全局因子
inertia = 0.5;      % 惯性因子
MinX = -65.536;     % 变量范围的最小值
MaxX = 65.536;     % 变量范围的最大值

% ------------------- 粒子位置初始化 -------------------
X = MinX + (MaxX - MinX) * rand(NP, D);
F = fun(X);
selfX = X;
selfF = F;
dX = zeros(NP, D);

% ------------------- 种群评估 -------------------
[Bestf, Indexf] = sort(F);
globalfi = Bestf(NP);             % 全局最优值
globalBestX = X(Indexf(NP),:);    % 全局最优数据

% ------------------- 程序主循环开始 -------------------
for gen = 1:1:maxgen
    time(gen) = gen;
    % ------------------- 粒子移动位置 -------------------
    for i = 1:1:NP
        for j = 1:1:D
            dX(i,j) = inertia * dX(i,j) + selfw * rand * (selfX(i,j) - X(i,j)) +...
                globalw * rand * (globalBestX(1,j) - X(i,j));
            X(i,j) = X(i,j) + dX(i,j); % 移动后的位置
            if X(i,j) > MaxX
                X(i,j) = MaxX;
            end
            if X(i,j) < MinX
                X(i,j) = MinX;
            end
        end
    end
    F = fun(X);
    % ------------------- 适应度统计 -------------------
    [Bestf, Indexf] = sort(F);
    Bestfi = Bestf(NP);        % 更新后的最优值
    BestX = X(Indexf(NP),:);   % 更新后的最优数据
    
    % ------------------- 更新自身最优 -------------------
    for i = 1:1:NP
        if F(i) >= selfF(i)
            selfF(i) = F(i);
            selfX(i,:) = X(i, :);
        end
    end
    % ------------------- 更新全局最优 -------------------
    if Bestfi >= globalfi
        globalfi = Bestfi;
        globalBestX = BestX;
    end
    % ------------------- 记录结果 -------------------
    BestJ(gen) = globalfi;
    if mod(gen, 10) == 0
        disp(sprintf('当前代数：%d; 当前结果：%f;',gen,globalfi));
    end
    plot(time, BestJ, 'r');
    axis([1, maxgen, 0, 1.1]);
    xlabel('迭代步数');ylabel('优化结果');drawnow;pause(0.1);
    
end
disp(sprintf('迭代步数：%d; 优化结果：%f;',gen,globalfi));

% ------------------- 子函数：目标函数 -------------------
function F = fun(X)
a = [-32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32;...
    -32 -32 -32 -32 -32 -16 -16 -16 -16 -16 0 0 0 0 0 16 16 16 16 16 32 32 32 32 32];
F = 0.002 * ones(size(X,1),1);
for j = 1:1:25
    F = F + 1./(j + (X(:,1) - a(1,j)) .^ 6 + (X(:,2) - a(2,j)) .^ 6); % 计算适应度
end
        
        