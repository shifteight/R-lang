# 多元回归的进一步推断

本章主要讨论同时对多个变量进行显著性检验、受限最小二乘法以及多元回归的模型设定问题（重点讨论变量选择）。假设MR1-MR6成立。

## 联合假设检验
对联合假设的检验采用$F$-test。比如：
$$SALES=\beta_1+\beta_2PRICE+\beta_3ADVERT+\beta_4ADVERT^2+e$$
希望检验广告支出是否影响SALES，需要同时对线性项和平方项进行检验，亦即：
$$H_0:\beta_3=0,\beta_4=0$$
$$H_1:\beta_3,\beta_4 \mathrm{至少一个不为}0$$
当$H_0$成立时，上面的模型就变成受限模型（restricted model）：
$$SALES=\beta_1+\beta_2 PRICE +e$$
$F$检验基于对受限模型残差平方和（$SSE_R$）和非受限模型残差平方和（$SSE_U$）的比较。增加变量个数将减小误差平方和，即$SSE_R-SSE_U\leq 0$。$F$检验就是考察这种差异是不是显著。相应的统计量为：
$$F=\frac{(SSE_R-SSE_U)/J}{\left. SSE_U \middle/ (N-K)\right.}$$
其中，$J$为限制数，$N$为观测数目，$K$为非受限模型中的系数个数。若$H_0$成立，该统计量服从$F(J,N-K)$。当两个平方和之间差异较大时，$F$较大，此时拒绝原假设。在上面的例子中，$F=8.44$，相应的*p*值为$P(F_{(2,71)}>8.44)=0.0005$，对于$0.01$或$0.05$的显著性水平，我们均应拒绝原假设，认为至少有一个系数不等于0，也就是说，广告支出确实对销售有显著影响。

$F$检验的一个重要应用是检验模型的整体显著性。对于模型：
$$y=\beta_1 + x_2\beta_2 + x_3\beta_3+\cdots+x_K\beta_K+e$$
设定：$H_0:\beta_2=\beta_3=\cdots=\beta_K=0, H_1:\mathrm{至少一个}\beta_K{不等于}0$

当原假设成立，受限模型为：
$$y_i=\beta_1 + e_i$$
\beta_1的LS估计为$b_1^*=\bar{y}$，受限误差平方和为：
$$SSE_R=\sum_{i=1}^N (y_i-b_1^\star)^2=\sum_{i=1}^N (y_i-\bar{y})^2=SST$$
未受限误差平方和为$SSE_U=SSE$，限制数为$J=K-1$，因此，$F$统计量为：
$$F=\frac{\left.(SST-SSE)\middle/(K-1)\right.}{\left.SSE\middle/(N-K)\right.}$$
