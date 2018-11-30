function VS
% ----------- �㷨���� --------------
psize = 50;                % ��������
MaxItr = 1e5;              % ����������
itr = MaxItr;              % �����������ֵ
count = 1;                 % �����������ֵ
% ----------- �������� ---------------
objfun = 'ackley';         % ���Ż���Ŀ�꺯��
dim = 10;                  % ����ά��
lowerlimit = -30;          % ��������
upperlimit = 30;           % ��������
% ---------- ���Բ��� ------------------
Mu = 0.5 * (upperlimit + lowerlimit) * ones(1,dim); % ����ȦԲ��
gmin = inf;                                         % ȫ����СĿ��ֵ
x = 0.1;                                            % gammaincinv(x,a) �Ĳ���
ginv = (1/x) * gammaincinv(x,1);                    % �ֱ���a=1ʱ�治��ȫ٤������ֵ
r = ginv * ((upperlimit - lowerlimit) / 2);         % ����Ȧ�뾶
% ---------------------- ��ѭ���� ----------------------------------
while(itr)
    % ---------------------- ������ѡ�� ---------------------------
    C = r .* randn(psize,dim);    % ������ֵΪ���׼��Ϊr��psize��dim�е����������
    Cs = bsxfun(@plus,C,Mu);      % ������ѡ�⣬��ʵ����Cs = C + Mu
    % ---------------------- Խ���޲� -----------------------------
    Cs(Cs < lowerlimit) = rand * (upperlimit - lowerlimit) + lowerlimit;
    Cs(Cs > upperlimit) = rand * (upperlimit - lowerlimit) + lowerlimit;
    % ---------------------- ����Ŀ��ֵ ---------------------------
    ObjVal = feval(objfun,Cs);    % ����Ŀ��ֵ
    fmin = min(ObjVal);           % ��¼��СĿ��ֵ
    MinFitInd = find(ObjVal == fmin);    % �ҵ���СĿ��ֵ���
    if numel(MinFitInd) > 1              % �����СĿ��ֵ��Ŷ���һ��
        MinFitInd = MinFitInd(1);        % ֻȡ�����е�һ��
    end
    itrBest = Cs(MinFitInd,1:dim);       % ��¼������������ý⣨�Ա�����
    % -------------------- �������Ž� --------------------------------
    if fmin < gmin              % ���µ���ý����ڴ洢����ý�
        gmin = fmin;            % ���µ���ý��滻�洢����ý�
        gbest = itrBest;        % ������ý���Ա���
    end
    % -------------------- ��ʾĿ��ֵ --------------------------------
    if mod(count,1000) == 0
        fprintf('Iter = %d ObjVal = %g\n',count,gmin); % ��ʾ��ý��Ŀ��ֵ
    end
    % ------------------- �������ĸ��� ------------------------------
    best(count) = gmin;          % ��¼��С����ֵ
    Mu = gbest;                  % ����һ����������Ϊ��ǰ���Ž�
    itr = itr - 1;               % �����������һ
    count = count + 1;           % �����������һ
    % ------------------- �뾶���� ----------------------------------
    a = itr / MaxItr;            % ���º���gammaincinv�Ĳ���a
    ginv = (1/x) * gammaincinv(x,a);  % ���㺯����1/x)*gammaincinv(x,1)����ֵ
    r = ginv * ((upperlimit - lowerlimit)/2); % �����µ������뾶
end
plot([1:count-1],best)
function fun=ackley(X)
NP = size(X,1);
for i = 1:NP
    fun(i,1) = 20 + exp(1) - 20*exp(-0.2*(sum(X(i,:).^2)/length(X(i,:)))^0.5)...
        -exp(sum(cos(2*pi*X(i,:)))/length(X(i,:)));
end