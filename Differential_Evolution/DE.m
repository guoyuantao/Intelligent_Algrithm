function DE
% --------�������� ---------
NP = 100;       % ��Ⱥ��ģ
D = 10;         % ��������
MinX = -30;     % ��Χ����
MaxX = 30;      % ��Χ����
alpha = 0.6;    % ��������
beta = 0.6;     % ��������
CR = 0.8;       % �������
Error = 1.0;    % �޶�����
Max_N = 1000;   % �޶�����

% -------- λ�ó�ʼ�� --------
for i = 1:1:D
    X(:,i) = MinX + (MaxX - MinX) * rand(NP,1);
    selfX(:,i) = X(:,i);
end
% -------- ���㺯��ֵ --------
F = fun(X);
selfF = F;
% -------- �����Ž� --------
[Bestf,Indexf] = sort(F,2);   % ��NP������ֵ����
Bestfi = Bestf(1);            % ��һ������ֵ��С
Bestp = Indexf(1);            % �����������

% ----------------- ������ѭ����ʼ -------------------------
for gen = 1:1:Max_N
    time(gen) = gen;
    % ---------- ������� --------
    for i= 1:1:NP
        flag1 = ceil(rand * NP); % ȡһ���������
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
    % --------- ������� ---------
    for i = 1:1:NP
        temp = rand(1,D);
        for j = 1:1:D
            if temp(j) > CR
                X(i,j) = selfX(i,j);
            end
        end
    end
    % --------- ���㺯��ֵ --------
    F = fun(X);
    % --------- ѡ����� ---------
    for i = 1:1:NP
        if F(i) >= selfF(i)
            F(i) = selfF(i);
            X(i,:) = selfX(i,:);
        end
    end
    % -------- �������� ---------
    for i = 1:1:NP
        selfF(i) = F(i);
        selfX(i,:) = X(i,:);
    end
    % -------- �����Ž� --------
    [Bestf, Indexf] = sort(F,2); % ��NP������ֵ����
    Bestfi = Bestf(1);
    Bestp = Indexf(1);
    % -------��¼��� ---------
    result(gen) = Bestfi;
    if mod(gen,10) == 0
        disp(sprintf('������%d -------- �����%f',gen,Bestfi));
        plot(time,result,'r');axis([1,Max_N, 0, 100]);
        xlabel('��������');ylabel('�Ż����');
        drawnow;pause(0.1);
    end
    if Bestfi < Error
        break;
    end
end
disp('');
disp(sprintf('����������%d ------- �Ż������%f',gen,Bestfi));
% ---- �Ӻ���:Ŀ�꺯�� ----
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
            