function ABC
% --------------- �������� ---------------
NP1 = 20;              % ��Ⱥ��ģ
NP2 = 20;              % ��Ⱥ��ģ
D = 10;                % ��������
MinX = -D^2;           % ��Χ����
MaxX = D^2;            % ��Χ����
Limit = 50;            % ������ֵ
Search = zeros(1,NP1);% �����Ѵ�
Error = 1.0;           % �޶�����
Max_N = 1000;          % �޶�����
% --------------- ��Դλ�ó�ʼ�� --------------
for i = 1:1:D
    X(:,i) = MinX + (MaxX - MinX) * rand(NP1+NP2,1);
end
% --------------- ���㺯��ֵ -----------------
F = fun(X);
% --------------- �����۷�Ⱥ -----------------
[Bestf, Indexf] = sort(F,2);
for i = 1:1:NP1
    X1(i,:) = X(Indexf(i),:);
    F1(i) = F(Indexf(i));
end
CX1 = X1;
CF1 = F1;
% --------------- ������ѭ����ʼ -----------------
for gen = 1:1:Max_N
    time(gen) = gen;
    % --------------- �����۷�Ⱥ���� -----------------
    for i = 1:1:NP1
        flag1 = ceil(rand * NP1);
        while(flag1 == i)
            flag1 = ceil(rand * NP1);
        end
        flag2 = ceil(rand * D);
        X1(i,flag2) = X1(i,flag2) + rands(1) * (X1(i,flag2) - X1(flag1,flag2));
    end
    % ---------------- ������ۺ���ֵ ----------------
    F1 = fun(X1);
    % ---------------- ���۷�̰������ ----------------
    for i = 1:1:NP1
        if F1(i) >= CF1(i)
            Search(i) = Search(i) + 1;
            X1(i,:) = CX1(i,:);
            F1(i) = CF1(i);
        else
            Search(i) = 0;
        end
    end
    % ---------------- ���ٷ�ѡ����� -----------------
    temp = (1 ./ (1 + F1)) / sum(1 ./ (1 + F1));
    for i = 1:1:NP1
        P(i) = sum(temp(1:i));
    end
    % --------------- ���ٷ���Դ���� -----------------
    for i = 1:1:NP2
        % -------------- ���ٷ�ѡ����Դ --------------
        rnd = rand;
        for flag = 1:1:NP1
            if rnd < P(flag)
                Genzong(i) = flag;
                break;
            end
        end
        X2(i,:) = X1(flag,:);
        % -------------- ���ٷ�������Դ --------------
        flag1 = ceil(rand * NP1);
        while(flag1 == flag)
            flag = ceil(rand * NP1);
        end
        flag2 = ceil(rand * D);
        X2(i,flag2) = X1(flag,flag2) + rands(1) * (X1(flag,flag2) - X1(flag1,flag2));
    end
    % ------------ ������ٺ���ֵ -------------------
    F2 = fun(X2);
    % ------------ ���ٷ�Դ���� -------------------
    for i = 1:1:NP2
        if F2(i) >= F1(Genzong(i))
            Search(Genzong(i)) = Search(Genzong(i)) + 1;
        else
            Search(Genzong(i)) = 0;
            X1(Genzong(i),:) = X2(i,:);
            F1(Genzong(i)) = F2(i);
        end
    end
    % ------------ ������Դ���������� --------------
    for i = 1:1:NP1
        if Search(i) > Limit
            Search(i) = 0;
            if i ~= Indexf(1)
                X1(i,:) = MinX + (MaxX - MinX) * rand(1,D);
                F1 = fun(X1);
            end
        end
    end
    % ------------- �������� ------------------
    CF1 = F1; 
    CX1 = X1;
    % ------------ �����Ž� -----------------
    [Bestf,Indexf] = sort(F1,2);
    gBestf = Bestf(1);
    gX = X1(Indexf(1),:);
    % ------------ ��¼��� -----------------
    result(gen) = gBestf;
    if mod(gen,10) == 0
        disp(sprintf('������%d ------- �����%f',gen,gBestf));
        plot(time,result,'r');axis([1,Max_N,0,10000]);
        xlabel('��������');ylabel('�Ż����');drawnow;pause(0.1);
    end
    if gBestf < Error
        break;
    end
end
disp('');
disp(sprintf('����������%d ------ �Ż������%f',gen, gBestf));
% ------------ ����1�� Ŀ�꺯�� -----------
function F = fun(X)
[M,N] = size(X);
for i = 1:1:M
    for j = 1:1:N
        x(j) = X(i,j);
    end
    F(i) = N * (N + 4) * (N - 1) / 6 + sum((x - 1) .^ 2) - ...
        sum(x(2:N) .* x(1:N-1));
end