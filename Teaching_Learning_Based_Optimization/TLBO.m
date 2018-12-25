function TLBO
% -------------------- ��������� -------------------
objfun      = 'zakharov';
D           = 50;
NP          = 50;
Max_N       = 1000;
MinX        = -5;
MaxX        = 10;
remove_num  = 0;          % ��¼�Ƴ��ظ�������
rand('state', sum(100 * clock));
% ---------------------- ��ʼ�� ---------------------
X = MinX + (MaxX - MinX) * rand(NP, D);
F = feval(objfun, X);
% --------------- ��¼������������ -------------------
fitcount   = NP;
% ------------------ �Ż���ʼ -----------------------
for gen = 1 : 1 : Max_N
    for i = 1 : 1 : NP
        % ---------- ��ʦ�׶� ----------
        [bestF, bestNo] = min(F);
        TX = X(bestNo(1), :);
        MX = mean(X);
        r = rand(1, D);
        TF = round(1 + rand);
        tmpX = X(i, :) + r .* (TX - TF * MX);
        tmpX = simplebounds(tmpX, MinX, MaxX);
        tmpF = feval(objfun, tmpX);
        % ---------- ̰������ -----------
        if tmpF < F(i)
            F(i) = tmpF;
            X(i, :) = tmpX;
        end
        % ---------- ѧ���׶� ----------
        R = randperm(NP);
        R = R(R~=i);
        r = rand(1, D);
        if F(i) < F(R(1))
            tmpX = X(i, :) + r .* (X(i, :) - X(R(1), :));
        else
            tmpX = X(i, :) + r .* (X(R(1), :) - X(i, :));
        end
        tmpX = simplebounds(tmpX, MinX, MaxX);
        tmpF = feval(objfun, tmpX);
        % ---------- ̰������ ----------
        if tmpF < F(i)
            F(i) = tmpF;
            X(i, :) = tmpX;
        end
    end
    % --------------- ��¼��� ---------------
    [X, flag] = remove_duplicate(X, MaxX, MinX); % �޸��ظ�����
    for i = 1 : 1 : NP
        if flag(i) == 1
            F(i) = feval(objfun, X(i, :));
        end
    end
    remove_num = remove_num + sum(flag);
    fitcount = fitcount + 2 * NP + sum(flag);
    best(gen) = bestF;
    gbest = TX;
    if mod(gen, 100) == 0
        disp(['������', num2str(gen), '----����ֵ��', num2str(bestF), '----����ֵ��', num2str(std(F))]);
    end
end
figure(1)
plot([1 : Max_N], best)
% -------------------- �Ӻ���1��Խ���޼� ------------------
function s = simplebounds(s, Lb, Ub)
ns_tmp = s;
I = ns_tmp < Lb;
ns_tmp(I) = Lb;
J = ns_tmp > Ub;
ns_tmp(J) = Ub;
s = ns_tmp;
return;
% -------------------- �Ӻ���2���Ƴ��ظ� -----------------
function [X, flag] = remove_duplicate(X, upper_limit, lower_limit)
flag = zeros(1, size(X, 1));
for i = 1 : size(X, 1)
    Mark_1 = sort(X(i, :));
    for k = i + 1 : size(X, 1);
        Mark_2 = sort(X(k, :));
        if isequal(Mark_1, Mark_2)
            flag(k) = 1;
            m_new = ceil(size(X, 2) * rand);
            X(k, m_new) = lower_limit +(upper_limit - lower_limit) * rand;
        end
    end
end
return;
% ------------------- �Ӻ���3��Ŀ�꺯�� ----------------
function [ObjVal] = zakharov(Cs)
dim = size(Cs, 2);
f1 = 0;
f2 = 0;
f3 = 0;
for j = 1 : dim
    f1 = f1 + Cs(:, j) .^ 2;
    f2 = f2 + 0.5 .* j .* Cs(:, j);
    f3 = f3 + 0.5 .* j .* Cs(:, j);
end
ObjVal = f1 + f2 .^ 2 + f3 .^ 4;