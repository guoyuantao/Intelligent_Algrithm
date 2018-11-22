function PSO
% ------------------- ���Բ��� -------------------
NP = 20;     % ��Ⱥ��ģ
D = 2;       % ��������
maxgen = 100;% �޶�����

% ------------------- ���Բ��� -------------------
selfw = 2.0;        % ��������
globalw = 2.0;      % ȫ������
inertia = 0.5;      % ��������
MinX = -65.536;     % ������Χ����Сֵ
MaxX = 65.536;     % ������Χ�����ֵ

% ------------------- ����λ�ó�ʼ�� -------------------
X = MinX + (MaxX - MinX) * rand(NP, D);
F = fun(X);
selfX = X;
selfF = F;
dX = zeros(NP, D);

% ------------------- ��Ⱥ���� -------------------
[Bestf, Indexf] = sort(F);
globalfi = Bestf(NP);             % ȫ������ֵ
globalBestX = X(Indexf(NP),:);    % ȫ����������

% ------------------- ������ѭ����ʼ -------------------
for gen = 1:1:maxgen
    time(gen) = gen;
    % ------------------- �����ƶ�λ�� -------------------
    for i = 1:1:NP
        for j = 1:1:D
            dX(i,j) = inertia * dX(i,j) + selfw * rand * (selfX(i,j) - X(i,j)) +...
                globalw * rand * (globalBestX(1,j) - X(i,j));
            X(i,j) = X(i,j) + dX(i,j); % �ƶ����λ��
            if X(i,j) > MaxX
                X(i,j) = MaxX;
            end
            if X(i,j) < MinX
                X(i,j) = MinX;
            end
        end
    end
    F = fun(X);
    % ------------------- ��Ӧ��ͳ�� -------------------
    [Bestf, Indexf] = sort(F);
    Bestfi = Bestf(NP);        % ���º������ֵ
    BestX = X(Indexf(NP),:);   % ���º����������
    
    % ------------------- ������������ -------------------
    for i = 1:1:NP
        if F(i) >= selfF(i)
            selfF(i) = F(i);
            selfX(i,:) = X(i, :);
        end
    end
    % ------------------- ����ȫ������ -------------------
    if Bestfi >= globalfi
        globalfi = Bestfi;
        globalBestX = BestX;
    end
    % ------------------- ��¼��� -------------------
    BestJ(gen) = globalfi;
    if mod(gen, 10) == 0
        disp(sprintf('��ǰ������%d; ��ǰ�����%f;',gen,globalfi));
    end
    plot(time, BestJ, 'r');
    axis([1, maxgen, 0, 1.1]);
    xlabel('��������');ylabel('�Ż����');drawnow;pause(0.1);
    
end
disp(sprintf('����������%d; �Ż������%f;',gen,globalfi));

% ------------------- �Ӻ�����Ŀ�꺯�� -------------------
function F = fun(X)
a = [-32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32 -32 -16 0 16 32;...
    -32 -32 -32 -32 -32 -16 -16 -16 -16 -16 0 0 0 0 0 16 16 16 16 16 32 32 32 32 32];
F = 0.002 * ones(size(X,1),1);
for j = 1:1:25
    F = F + 1./(j + (X(:,1) - a(1,j)) .^ 6 + (X(:,2) - a(2,j)) .^ 6); % ������Ӧ��
end
        
        