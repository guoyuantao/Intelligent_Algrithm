"""
---------- 遗传算法 ----------
GA基本组成：
    目标函数：GA基于个体实应度操作，合理选择适应度函数，可体现个体优劣
    算法参数：种群规模，基因维数，交叉概率，遗传概率
    遗传算子：初始化、选择、交叉、变异
    终止条件：迭代步数或精度阈值
-----------------------------
"""
import numpy as np
class GA():
    def __init__(self):
        """ 初始化参数 """
        # ---- 共性参数 ----
        self.NP = 50             # 种群规模
        self.Max_iter_N = 10000  # 限定迭代代数
        self.Pc = 0.8            # 交叉概率
        self.Pm = 0.01           # 变异概率
        # ---- 个性参数 ----
        self.D = 30              # 种群维度
        self.Minx = -100         # 候选解空间最小值
        self.MaxX = 100          # 候选解空间最大值
        self.Error = 1.0e-10     # 允许错误率

    def init_solution(self):
        """ 初始化候选解 """
        # ---- 候选解 ----
        self.X = self.Minx + (self.MaxX - self.Minx) * np.random.random((self.NP, self.D))
        self.F = self.fun1(self.X)
        self.index = np.where(self.F == np.min(self.F, axis=0))
        self.bestX = self.X[self.index]
        return self.X

    def fun1(self, X):
        return np.sum(X ** 2,1)

    def copy(self, X):
        """ 复制 """
        tempF = np.cumsum(1/self.F/np.sum(self.F))
        self.CX = self.X
        for i in range(1, self.NP+1):
            rnd = np.random.random()
            for flag in range(1, self.NP+1):
                if rnd < tempF[flag]:
                    X[i,:] = self.CX[flag,:]
                    break
        X[self.NP, :] = self.bestX
        return X
    def overlapping(self, X):
        """ 交叉 """
        Pc_rand = np.random.random((1, self.NP))
        for i in range(1, self.NP+1, 2):
            if Pc_rand[i] < self.Pc:
                alfa = np.random.random()
                X[i] = alfa * X[i+1] + (1 - alfa) * X[i]
                X[i+1] = alfa * X[i] + (1 - alfa) * X[i+1]
        return X
    def variation(self, X):
        """ 变异 """
        Pm_rand = np.random.random((self.NP, self.D))
        for i in range(1, self.NP+1):
            for j in range(1, self.D):
                X[i,j] = self.Minx + (self.MaxX - self.Minx) * np.random.random()
        X[self.NP] = self.bestX
        return X

    def optimization(self):
        """ 迭代优化 """
        for gen in range(1, 10001):
            x = self.init_solution()
            x1 = self.copy(x)
            x2 = self.overlapping(x1)
            x3 = self.variation(x2)
            F = self.fun1(x3)
            index = np.where(self.F == np.min(self.F, axis=0))
            bestX = self.X[self.index]
            bestF = self.fun1(bestX)
            if bestF < self.Error:
                break
            if np.mod(gen, 100) == 0:
                print("代数：%d ----最优解：%d", (gen, bestF))


ga = GA()
ga.optimization()
