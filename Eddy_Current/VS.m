function VS
% ----------- 算法参数 --------------
psize = 50;                % 邻域解个数
MaxItr = 1e5;              % 最大迭代步数
itr = MaxItr;              % 反向计数器初值
count = 1;                 % 正向计数器初值
% ----------- 函数参数 ---------------
objfun = 'ackley';         % 被优化的目标函数
dim = 10;                  % 变量维数
lowerlimit = -30;          % 变量下限
upperlimit = 30;           % 变量上限
% ---------- 个性参数 ------------------
Mu = 0.5 * (upperlimit + lowerlimit) * ones(1,dim); % 最外圈圆心
gmin = inf;                                         % 全局最小目标值
x = 0.1;                                            % gammaincinv(x,a) 的参数
ginv = (1/x) * gammaincinv(x,1);                    % 分辨率a=1时逆不完全伽马函数的值
r = ginv * ((upperlimit - lowerlimit) / 2);         % 最外圈半径
% ---------------------- 主循环体 ----------------------------------
while(itr)
    % ---------------------- 建立候选解 ---------------------------
    C = r .* randn(psize,dim);    % 产生均值为零标准差为r的psize行dim列的随机数矩阵
    Cs = bsxfun(@plus,C,Mu);      % 产生候选解，其实就是Cs = C + Mu
    % ---------------------- 越界修补 -----------------------------
    Cs(Cs < lowerlimit) = rand * (upperlimit - lowerlimit) + lowerlimit;
    Cs(Cs > upperlimit) = rand * (upperlimit - lowerlimit) + lowerlimit;
    % ---------------------- 计算目标值 ---------------------------
    ObjVal = feval(objfun,Cs);    % 计算目标值
    fmin = min(ObjVal);           % 记录最小目标值
    MinFitInd = find(ObjVal == fmin);    % 找到最小目标值序号
    if numel(MinFitInd) > 1              % 如果最小目标值序号多余一个
        MinFitInd = MinFitInd(1);        % 只取阿门中的一个
    end
    itrBest = Cs(MinFitInd,1:dim);       % 记录迭代产生的最好解（自变量）
    % -------------------- 更新最优解 --------------------------------
    if fmin < gmin              % 若新的最好解优于存储的最好解
        gmin = fmin;            % 用新的最好解替换存储的最好解
        gbest = itrBest;        % 更新最好解的自变量
    end
    % -------------------- 显示目标值 --------------------------------
    if mod(count,1000) == 0
        fprintf('Iter = %d ObjVal = %g\n',count,gmin); % 显示最好解的目标值
    end
    % ------------------- 涡流中心更新 ------------------------------
    best(count) = gmin;          % 记录最小函数值
    Mu = gbest;                  % 将下一涡流中心置为当前最优解
    itr = itr - 1;               % 反向叠加数减一
    count = count + 1;           % 正向叠加数加一
    % ------------------- 半径更新 ----------------------------------
    a = itr / MaxItr;            % 更新函数gammaincinv的参数a
    ginv = (1/x) * gammaincinv(x,a);  % 计算函数（1/x)*gammaincinv(x,1)的新值
    r = ginv * ((upperlimit - lowerlimit)/2); % 计算新的涡流半径
end
plot([1:count-1],best)
function fun=ackley(X)
NP = size(X,1);
for i = 1:NP
    fun(i,1) = 20 + exp(1) - 20*exp(-0.2*(sum(X(i,:).^2)/length(X(i,:)))^0.5)...
        -exp(sum(cos(2*pi*X(i,:)))/length(X(i,:)));
end