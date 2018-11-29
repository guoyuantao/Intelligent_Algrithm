function ABC
% --------------- 参数设置 ---------------
NP1 = 20;              % 种群规模
NP2 = 20;              % 种群规模
D = 10;                % 变量个数
MinX = -D^2;           % 范围下限
MaxX = D^2;            % 范围上限
Limit = 50;            % 次数阈值
Search = zeros(1,NP1);% 采蜜搜次
Error = 1.0;           % 限定精度
Max_N = 1000;          % 限定代数
% --------------- 蜜源位置初始化 --------------
for i = 1:1:D
    X(:,i) = MinX + (MaxX - MinX) * rand(NP1+NP2,1);
end
% --------------- 计算函数值 -----------------
F = fun(X);
% --------------- 建采蜜蜂群 -----------------
[Bestf, Indexf] = sort(F,2);
for i = 1:1:NP1
    X1(i,:) = X(Indexf(i),:);
    F1(i) = F(Indexf(i));
end
CX1 = X1;
CF1 = F1;
% --------------- 程序主循环开始 -----------------
for gen = 1:1:Max_N
    time(gen) = gen;
    % --------------- 作采蜜峰群搜索 -----------------
    for i = 1:1:NP1
        flag1 = ceil(rand * NP1);
        while(flag1 == i)
            flag1 = ceil(rand * NP1);
        end
        flag2 = ceil(rand * D);
        X1(i,flag2) = X1(i,flag2) + rands(1) * (X1(i,flag2) - X1(flag1,flag2));
    end
    % ---------------- 计算采蜜函数值 ----------------
    F1 = fun(X1);
    % ---------------- 采蜜蜂贪婪搜索 ----------------
    for i = 1:1:NP1
        if F1(i) >= CF1(i)
            Search(i) = Search(i) + 1;
            X1(i,:) = CX1(i,:);
            F1(i) = CF1(i);
        else
            Search(i) = 0;
        end
    end
    % ---------------- 跟踪蜂选择概率 -----------------
    temp = (1 ./ (1 + F1)) / sum(1 ./ (1 + F1));
    for i = 1:1:NP1
        P(i) = sum(temp(1:i));
    end
    % --------------- 跟踪峰蜜源搜索 -----------------
    for i = 1:1:NP2
        % -------------- 跟踪峰选择蜜源 --------------
        rnd = rand;
        for flag = 1:1:NP1
            if rnd < P(flag)
                Genzong(i) = flag;
                break;
            end
        end
        X2(i,:) = X1(flag,:);
        % -------------- 跟踪峰搜索蜜源 --------------
        flag1 = ceil(rand * NP1);
        while(flag1 == flag)
            flag = ceil(rand * NP1);
        end
        flag2 = ceil(rand * D);
        X2(i,flag2) = X1(flag,flag2) + rands(1) * (X1(flag,flag2) - X1(flag1,flag2));
    end
    % ------------ 计算跟踪函数值 -------------------
    F2 = fun(X2);
    % ------------ 跟踪蜂源计数 -------------------
    for i = 1:1:NP2
        if F2(i) >= F1(Genzong(i))
            Search(Genzong(i)) = Search(Genzong(i)) + 1;
        else
            Search(Genzong(i)) = 0;
            X1(Genzong(i),:) = X2(i,:);
            F1(Genzong(i)) = F2(i);
        end
    end
    % ------------ 检验蜜源不进化次数 --------------
    for i = 1:1:NP1
        if Search(i) > Limit
            Search(i) = 0;
            if i ~= Indexf(1)
                X1(i,:) = MinX + (MaxX - MinX) * rand(1,D);
                F1 = fun(X1);
            end
        end
    end
    % ------------- 迭代更新 ------------------
    CF1 = F1; 
    CX1 = X1;
    % ------------ 求最优解 -----------------
    [Bestf,Indexf] = sort(F1,2);
    gBestf = Bestf(1);
    gX = X1(Indexf(1),:);
    % ------------ 记录结果 -----------------
    result(gen) = gBestf;
    if mod(gen,10) == 0
        disp(sprintf('代数：%d ------- 结果：%f',gen,gBestf));
        plot(time,result,'r');axis([1,Max_N,0,10000]);
        xlabel('迭代参数');ylabel('优化结果');drawnow;pause(0.1);
    end
    if gBestf < Error
        break;
    end
end
disp('');
disp(sprintf('迭代步数：%d ------ 优化结果：%f',gen, gBestf));
% ------------ 函数1： 目标函数 -----------
function F = fun(X)
[M,N] = size(X);
for i = 1:1:M
    for j = 1:1:N
        x(j) = X(i,j);
    end
    F(i) = N * (N + 4) * (N - 1) / 6 + sum((x - 1) .^ 2) - ...
        sum(x(2:N) .* x(1:N-1));
end