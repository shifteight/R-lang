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

$t$检验和$F$检验的关系：当原假设是一个单等式假设、备择假设为“不等于”时，两者是等价的（这源自$t$分布和$F$分布的关系：服从$df$自由度$t$分布的随机变量的平方，服从自由度为$(1,df)$的$F$分布）。看销售例子中PRICE对SALES的影响，如果$H_0:\beta_2=0$，$H_1:\beta_2\neq 0$，则相应$t$统计量值为$7.64/1.046=7.3044$，而$F=53.355$，正好等于$t^2$。但是，这种关系在单侧检验中并不成立，因为$F$检验并不适用于备择假设为$>$或$<$的情况。而且，这种关系对于多限制原假设也不成立。

$F$检验可用于任何不超过$K$个线性等式假设的情况。虽然此时从$H_0$导出限制模型并不容易，但基本原理是不变的。比如，我们做如下检验：
$$H_0:\beta_3+3.8\beta_4=1\qquad H_1:\beta_3+3.8\beta_4\neq 1$$
当$H_0$成立时，$\beta_3=1-3.8\beta_4$，代入未受限模型，稍加整理，可得受限模型：
$$(SALES-ADVERT)=\beta_1+\beta_2PRICE+\beta_4(ADVERT^2-3.8ADVERT)+e$$
令$y=SALES-ADVERT,x_2=PRICE,x_3=ADVERT^2-3.8ADVERT$，应用最小二乘法估计，可得受限误差平方和$SSE_R=1552.286$，未受限误差平方和与以前一样，$SSE_U=1532.084$，限制数$J=1$，自由度$N-K=71$，易得$F$统计量的值为$0.936$。对于$\alpha=0.05$，$F_c=3.976$，因此，我们不能拒绝$H_0$。换句话说，每月1900的广告支出是最优决策。（注意到，这里的原假设只有一个限制，因此也可以用$t$检验，容易计算$t=0.9676$，从而$t^2=F$。）进一步，如果我们要检验最优支出是否大于1.9，需要设定如下假设：
$$H_0:\beta_3+3.8\beta_4\leq 1\qquad H_1:\beta_3+3.8\beta_4>1$$
因为假设中包含了不等号，$F$检验不适用，只能用$t$检验。实践中，我们借助软件更方便，上述这些检验都属于一类称为Wald tests的检验。

## 非样本信息
看一个啤酒需求的例子。设定如下对数模型：
$$\ln(Q)=\beta_1+\beta_2\ln(PB)+\beta_3\ln(PL)+\beta_4\ln(PR)+\beta_5\ln(I)$$
其中，$Q$为需求量，$PB$为beer的价格，$PL$为liquor的价格，$PR$为其他商品和服务的价格，$I$为收入。采用对数的好处是，排除了负的价格。一个非样本信息是，当所有价格和收入同比例增加时，需求不变（经济主体不受“货币幻觉”影响）。为了描述这个特征，将所有自变量乘上一个常数$\lambda$：
$$
\begin{align}
\ln(Q) &= \beta_1+\beta_2\ln(\lambda PB)+\beta_3\ln(\lambda PL)+\beta_4\ln(\lambda PR)+\beta_5\ln(\lambda I) \\
       &= \beta_1+\beta_2\ln(PB)+\beta_3\ln(PL)+\beta_4\ln(PR)+\beta_5\ln(I) +(\beta_2+\beta_3+\beta_4+\beta_5)\ln\lambda
\end{align}
$$
因此，上面的非样本信息，可以归结为一个特殊限制：$\beta_2+\beta_3+\beta_4+\beta_5=0$。为了得到满足这个限制的参数估计，我们从下面的回归模型开始：
$$\ln(Q)=\beta_1+\beta_2\ln(PB)+\beta_3\ln(PL)+\beta_4\ln(PR)+\beta_5\ln(I)+e$$
样本数据集为beer.dat。为了引入非样本信息，我们从限制中解出某个参数，比如：
$$\beta_4 = -\beta_2-\beta_3-\beta_5$$
代入原来的模型，得到：
$$
\begin{align}
\ln(Q) &= \beta_1+\beta_2\ln(\lambda PB)+\beta_3\ln(\lambda PL)+-\beta_2-\beta_3-\beta_5 \ln(\lambda PR)+\beta_5\ln(\lambda I)+e \\
       &= \beta_1+\beta_2[\ln(PB)-\ln(PR)]+\beta_3[\ln(PL)-\ln(PR)]+\beta_5[\ln(I)-\ln(PR)] +e \\
       &= \beta_1+\beta_2\ln\left(\frac{PB}{PR}\right)+\beta_3\ln\left(\frac{PL}{PR}\right)+\beta_5\ln\left(\frac{I}{PR}\right)+e
\end{align}
$$
其中，我们消去了$\beta_4$，且构造了几个新变量，得到一个受限模型。对其进行估计，可以得到：
$$b_1^\star=-4.789,b_2^\star=-1.2994,b_3^\star=0.1868,b_5^\star=0.9485$$
再由限制得到，$b_4^\star=0.1668$。

那么，这个受限最小二乘估计过程有什么性质呢？首先，它是有偏的，除非限制是完全正确的。这个结果对于计量经济学意义重大。好的经济学家将找到更可靠的估计，因为他们将引入更好的非样本信息。这点在模型设定方面也是一样。记住：好的经济理论是实证研究中的一个重要组成部分。其次，受限最小二乘估计的方差比通常的最小二乘估计小，无论限制是否成立。也就是说，引入非样本信息，会降低估计过程因随机抽样产生的变异性。注意：这里面有一个bias-variance权衡的问题。

## 模型设定
遗漏变量。
无关变量。
模型选择的准则。

## 数据不足（Poor Data）、共线性（Collinearity）和不显著（Insignificance）

## 预测