# 数据结构

## 向量


## 属性

所有的对象都可以添加任意的属性（attributes），这些属性用来存储关于对象的元数据（metadata）。属性可以想象为命名列表（named list）（其中names都是唯一的）。属性可以通过``attr()``逐个获取，也可以用``attributes()``一次全部获取。

	y <- 1:10
	attr(y, "my_attribute") <- "This is a vector"
	attr(y, "my_attribute")
	#> [1] "This is a vector"
	str(attributes(y))
	#> List of 1
	#> $ my_attribute: chr "This is a vector"

``structure()``函数返回一个带有修改后属性的新对象：

	structure(1:10, my_attribute="This is a vector")
	#> [1]  1  2  3  4  5  6  7  8  9 10
	#> attr(,"my_attribute")
	#> [1] "This is a vector"

默认情况下，向量被修改时大多数属性将丢失：
	
	attributes(y[1])
	#> NULL
	attributes(sum(y))
	#> NULL

只有三个最重要的属性不会丢失：

- Names
- Dimensions
- Class

这三个属性都具有各自的读取函数，分别是``names()``, ``dim()``, ``class()``，不要用``attr(,'names')``等。

## 矩阵与数组
矩阵和数组分别由 ``matrix()``和``array()``构建，或者从``dim()``的赋值形式构建：
	
	

## 数据框
数据框（data frame）是等长向量的列表，它既有matrix的性质，也有list的性质。

# 取子集

- 三种子集选取操作符
- 六种选取类型
- 不同类型对象子集选取的区别
- 取子集与赋值结合使用

## 数据类型
对于原子向量，取子集操作符是``[``，可以用五种方式取子集，分别是正数索引（实质上是一个向量）、负数索引、逻辑向量、空（Nothing）、零，其中，空索引返回原来的向量，零索引返回长度为0的向量。如果向量是命名的，也可用字符向量作为索引。

对于列表，可以用``[``、``[[``、``$``来索引。下面详述。

对于矩阵和数组，可以用多个向量、单个向量或一个矩阵来索引。当使用单个向量作为索引时，实际上是把原矩阵作为（列主序）向量来看待。

对于数据框，索引可以是单个向量（此时就像列表）或两个向量（此时就像矩阵）。选取数据框中的列，有两种方式：一种如同对待列表，比如``df[c('x', 'z')]``；一种如同对待矩阵，比如``df[, c('x', 'z')]``。当选取一列时，列表方式和矩阵方式有个重要差别：矩阵方式得到一个向量（实际上是经过简化的结果），而列表方式不作这种简化，即结果仍是一个列表。

此外，还有两种类型：S3对象，由组成类型决定；S4对象，详见后述。

## 子集选取操作符
除了``[``，还有两个操作符``[[``和``$``。``[[``一般用来选取列表（子集）中的值，``[``做不到这点，它只能返回列表。``$``是``[[``的快捷方式，尤其是与字符索引一起用。数据框本质是一个列表，因此可以用``[[``选取某一列。S3和S4对象会重载[和[[的标准行为（由具体类型而定），其区别在于是否对结果进行简化，亦即simplifying subsetting or preserving subsetting。对所有数据类型，preserving的行为都一样，即输出保留输入的类型；而simplifying对于不同类型有不同行为：

(@) 对atomic vector：移除names
(@) 对list：返回列表内部对象（值）
(@) 对factor：丢弃未用到的levels
(@) 对matrix或array：丢弃长度为1的dimension
(@) 对data frame：如果输出只有一列，则返回向量形式（而不是数据框）

``$``操作符是快捷方式，``x$y``等价于``x[["y", exact=FALSE]]``。

缺失（missing）索引和越界（out-of-bounds）索引：


Operator     Index        Atomic       List
---------   -----------  --------   --------------
[            OOB          NA           list(NULL)
[            NA_real_     NA           list(NULL)
[            NULL         x[0]         list(NULL)
[[           OOB          Error        Error
[[           NA_real_     Error        NULL
[[           NULL         Error        Error

Table: Missing/out of bounds indices

当输入是命名向量时，OOB、NA_real__、NULL索引的names全部为“``<NA>``”。

获取列表内容的一个例子：
    
    mod <- lm(mpg ~ wt, data=mtcars)
    mod$df.residual       # 获取残差的自由度
    smod <- summary(mod)
    smod$adj.r.squared    # 获取R方

子集赋值：取子集与赋值一起使用。此时，要注意几点：

- 不检查重复索引，当索引重复时，取最后一次赋值
- ``NA``不能在子集赋值中使用，除了与逻辑索引连用，此时作为``FALSE``处理，该方式在根据条件更改向量时非常有用

<!-- -->

    df <- data.frame(a=c(1, 10, NA))
    df$a[df$a < 5] <- 0
    df$a
    #> [1] 0 10 NA

空索引可用来维持原来对象的类别（class）和结构（structure），比如：
    
    mtcars[] <- lapply(mtcars, as.integer)    # 返回data frame
    mtcars <- lapply(mtcars, as.integer)      # 返回list

对于list，可用“取子集+赋值+NULL”来移除元素。若要向list中添加一个NULL，可用`[`和``list(NULL)``：

    x <- list(a=1, b=2)
    x[['b']] <- NULL
    str(x)
    
    y <- list(a=1)
    y['b'] <- list(NULL)
    str(y)