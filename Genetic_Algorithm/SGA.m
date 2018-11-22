function SGA
% -------- ���Բ��� ---------
NP = 50;         % ��Ⱥ��ģ
Max_N = 10000;   % �޶�����
Pc = 0.80;       % �������
Pm = 0.01;       % �������

% -------- ���Բ��� ----------
D = 30;          % ��Ⱥά��
MinX = -100;     % ��ѡ��ռ���Сֵ
MaxX = 100;      % ��ѡ��ռ����ֵ
Error = 1.0e-10; % ����Ĵ�����

% -------- ��ʼ�� ----------
X = MinX + (MaxX - MinX) * rand(NP,D);
F = fun1(X);
[bestF, bestlow] = min(F);  % �����Сֵ����Сֵ����
bestX = X(bestlow,:);       % �洢������Ž��X��������

% -------- �Ż���ʼ ----------
for gen = 1:1:Max_N
    time(gen) = gen;
    % -------- ���Ʋ��� ----------
    tempF = cumsum(1 ./ F / sum(1 ./F ));  % ����ۼӺ�
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
    % -------- ��Ⱥ���� ----------
    Pc_rand = rand(1, NP);
    for i = 1:2:(NP-1)
        if Pc_rand(i) < Pc
            alfa = rand;
            X(i, :) = alfa * X(i+1, :) + (1 - alfa) * X(i, :);
            X(i+1,:) = alfa * X(i, :) + (1 - alfa) * X(i+1, :);
        end
    end
    % -------- ��Ⱥ���� ----------
    Pm_rand = rand(NP,D);
    for i = 1:1:NP
        for j = 1:1:D
            if Pm_rand(i,j) < Pm
                X(i,j) = MinX + (MaxX - MinX) * rand;
            end
        end
    end
    X(NP,:) = bestX;
    % -------- �㺯��ֵ ----------
    F = fun1(X);
    % -------- ��Ⱥ���� ----------
    [bestF, bestlow] = min(F);
    bestX = X(bestlow, :);
    % -------- ��¼��� ----------
    result(gen) = bestF;
    if bestF < Error
        break;
    end
    if mod(gen, 100) == 0
        disp(['������', num2str(gen), '----���ţ�', num2str(bestF)]);
    end
end
plot(time, result)
% -------- �Ӻ���1��Ŀ�꺯�� ----------
function f1 = fun1(X)
for i = 1:1:length(X(:,1))
    f1(i) = sum(X(i,:) .^ 2);
end
    