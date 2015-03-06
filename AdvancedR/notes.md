% R高级编程
% Kevin Qian
% 2015年3月

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

## 子集赋值

可以通过取子集与赋值一起使用来改变对象内容。此时，要注意几点：

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

## 应用实例

### 查询表（字符索引, c.s.）
### 匹配和手工合并（i.s.）
### 随机抽样／bootstrap（i.s.）

    df <- data.frame(x=rep(1:3, each=2), y=6:1, z=letters[1:6])
    set.seed(10)
    # randomly reorder
    df[sample(nrow(df)), ]
    # select 6 bootstrap replicates
    df[sample(nrow(df), 6, rep=T), ]  
    
### 排序（i.s.）
``order()``函数与整数索引结合，可以对对象排序。比如：

    df2 <- df[sample(nrow(df)), 3:1]
    df2[order(df2$x),]  # 按`x`列排序
    df2[, order(names(df2))]  # 升序重排各列

### Expanding aggregated counts (i.s.)

    df <- data.frame(x=c(2,4,1), y=c(9,11,6), n=c(3,5,1))
    df[rep(1:nrow(df), df$n), 1:2]

### Removing columns from data frames (c.s.)
比如，想从一个数据框中移除部分列，可以用三种方式：（1）将想移除的列设为NULL；（2）以单向量索引方式取子集；（3）与（2）类似，但使用``setdiff()``。

### Selecting rows based on a condition (l.s.)
一般采用``subset()``函数来简化代码：
    
    subset(mtcars, gear==5)
    subset(mtcars, gear==5 & cyl==4)

注意：逻辑表达式中要用向量布尔操作符``&``和``|``而不是短路操作符``&&``和``||``。``subset()``在非标准求值（non-standard evaluation）中还要谈到。

### Boolean algebra vs. sets (l.s. & i.s.)
布尔代数（逻辑索引）和集合运算（整数索引）是等价的，但在下面情况下，集合运算更高效：

- 寻找第一或最后一个``TRUE``；
- 存在很少几个``TRUE``、很多``FALSE``（此时，集合表示更快且占用更少空间）

``which()``函数将布尔表示转化为整数索引，但R base中却没有反过来的操作，可以自己编写一个：

    x <- sample(10) < 4
    which(x)
    
    unwhich <- function(x, n) {
      out <- rep_len(FALSE, n)
      out[x] <- TRUE
      out
    }

    unwhich(which(x), 10)

# 函数
掌握R高级编程的一个前提是对函数内在机理有深刻理解。其中，最关键的是要理解R的函数本身是对象，你可以用对其他任何类型对象的处理方式去处理函数。这点在后面的函数式编程（functional programming）中详述。本节内容包括：

- Function components（函数组成部分）
- Lexical scoping（词法作用域）
- 所有的操作都是函数调用
- 函数参数的三种方式，给定参数list如何调用函数，惰性求值
- 特殊调用：infix函数、替代函数（replacement function）
- 返回值，如何确保函数退出前做某些事情

注：本节需要用到``pryr``包。

## 函数组成
函数由三个部分组成：

- ``body()``：函数体代码
- ``formals()``：参数列表
- ``environment()``：函数变量的位置映射

因为函数是对象，它也具有额外属性，base R用到的一个属性是“srcref”，指向创建函数的源代码，它与``body()``返回值不同，包含了注释和格式。

对于内置函数（primitive functions）（C语言写成），formals、body和environment返回的都是NULL。

下面的代码获取base包中所有函数：

    objs <- mget(ls('package:base'), inherits=TRUE)
    funs <- Filter(is.function, objs)

## 词法作用域
R中有两类作用域：词法作用域（语言层面自动实现）和动态作用域（交互分析中选择函数）。词法作用域的规则可以概括为：只看定义、不看调用。背后有四个基本原理：

- 名称覆盖（name masking）
- 函数 vs. 变量
- a fresh start
- 动态查找（dynamic lookup）

### 名称覆盖
R逐层（环境嵌套）往上查找values。闭包的一个例子：

    j <- function(x) {
      y <- 2
      function() {
        c(x, y)
      }
    }
    k <- j(1)
    k()
    rm(j, k)

R中的环境（envrionments）提供了一些指针（pointers），可以用来查看每个函数关联哪些变量。

### 函数与变量
查找函数的规则与查找变量是一样的，只有一个小小的区别：当在一个明显需要函数的位置使用一个名称时，R在查找的时候会忽略所有不是函数的对象。

### A fresh start
在函数多次调用期间，变量会发生什么？看下面例子：

    j <- function() {
      if (!exists('a')) {
        a <- 1
      } else {
        a <- a + 1
      }
      print(a)
    }
    j()
    rm(j)

函数j()每次都返回1，因为每次一个函数被调用时，都会创建一个新的环境。函数无法知道上次运行时发生了什么，即每次调用都是独立的。（与此不同的方式是mutate state）。

### 动态查找
R是在函数运行时（而不是定义时）查找变量，因此函数的输出将取决与外层环境的对象。而这意味着函数不再是self-contained。为了检测这个问题，可以用``codetools``包中的``findGlobals()``函数：

    f <- function() x + 1
    codetools::findGlobals(f)
    #> [1] "+" "x"

或者，手工将函数的环境变成``emptyenv()``：
  
    environment(f) <- emptyenv()
    f()
    #> Error...

## 所有操作皆函数调用
记住John Chambers的两句话：

- R中所有东西都是对象（意味着每个内置函数可以重定义）；
- R中所有发生的事情都是函数调用（这个想法有助于对元编程的理解）

## 函数参数
函数调用时参数匹配的顺序是：完整名字 `>` 前缀 `>` 位置。如果给定一个参数的list，如何传递给函数？需要用``do.call()``：

    do.call(mean, list(1:10, na.rm=TRUE))

R允许使用默认参数和缺失参数，参数默认值可以基于其他参数的值定义，甚至可以用函数内部定义的值（base R中常用，但实践中不鼓励使用）。可以用``missing()``函数判断某个参数是否缺省：

    i <- function(a, b) {
      c(missing(a), missing(b))
    }
    i()
    i(a = 1)
    i(1, 2)

默认情况下，R中的参数是惰性求值的，即只在真的用到时才求值。比如下面的参数不会被求值：

    f <- function(x) {
      10
    }
    f(stop("This is an error!"))
    #> [1] 10

如果要确保参数求值，可以用``force()``函数：

    f <- function(x) {
      force()
      10
    }
    f(stop("This is an error!"))
    #> Error in force(x): This is an error!

这点对于在闭包创建时使用``lapply()``或循环非常重要：

    add <- function(x) {
      function(y) x + y
    }
    adders <- lapply(1:10, add)
    adders[[1]](10)
    #> [1] 20
    adders[[10]](10)
    #> [1] 20
    
上述代码中的``x``直到调用某个``add``函数才被求值，此时循环已经结束，``x``最后的值为10。因此，所有的add函数都是把10加到输入参数上，而这或许不是你想要的！手工强制求值可以解决这个问题：

    add <- function(x) {
      force(x)
      function(y) x + y
    }
    adders2 <- lapply(1:10, add)
    adders2[[1]](10)
    #> [1] 11
    adders2[[10]](10)
    #> [1] 20

由于默认参数是在函数内部求值的，所以如果表达式依赖当前环境，则结果取决于使用默认值还是显式提供。

技术上说，未被求值的参数称为承诺（promise）（有时也叫thunk），它包含两个部分：

- 被延迟计算的表达式
- 该表达式创建和求值的环境

第一次访问promise时，表达式被求值，然后值被缓存（cache），后续访问直接获得缓存的值而无需重新计算（不过原有的表达式仍然与值关联，所以``substitute()``仍然可以访问它）。通过``pryr::promise_info()``函数可以得到promise的更多信息（采用C++代码在无须求值的情况下获取promise信息，纯R代码无法做到这点）。

有一个特殊参数是``...``，用来匹配任何其他未匹配到的参数，可以很容易地传递给其他函数。``...``常与S3通用（广义）函数连用，使得单个方法更具灵活性。一个相对复杂的用法是``plot``函数，其中的``...``代表“其他图形参数”（``par()``的文档中列出了这些参数）。

为了将``...``捕捉到一个易于操作的形式里，可以使用``list()``（更多捕捉方法参见：capturing unevaluated dots一节）：

    f <- function(...) {
      names(list(...))
    }
    f(a = 1, b = 2)
    #> [1] "a" "b"

## 特殊调用
两类特殊调用：中缀（infix）函数和替代（replacement）函数。

大多数R函数都是前缀（prefix）函数。可以用``%%``来创建自定义infix函数。比如，可以创建一个连接字符串的操作符：

    `%+%` <- function(a, b) paste0(a, b)
    "new" %+% " string"

infix操作符遵循左结合的优先级规则。下面这个infix非常有用：

    `%||%` <- function(a, b) if (!is.null(a)) a else b
    function_that_might_return_null() %||% default_value

replacement函数的行为“**类似于**”对参数进行in place的修改，具有特殊的名字形式``xxx<-``。通常，具有两个参数（``x``和``value``）。比如：

    `second<-` <- function(x, value) {
      x[2] <- value
      x
    }
    x <- 1:10
    second(x) <- 5L
    x
    #> [1] 1 5 3 4 5 6 7 8 9 10

当R对赋值表达式``second(x) <- 5``求值时，发现``<-``左边并不是一个简单的名字，因此它一个名称为``second<-``的函数并作替换。

之所以说replacement函数“类似于”in place修改，因为它们实际上创建了修改后的副本。我们可以通过``pryr::address()``来查找对象的内存地址。

    library(pryr)
    x <- 1:10
    address(x)
    second(x) <- 6L
    address(x)

用``.Primitive()``实现的内置函数作in place修改：

    x <- 1:10
    address(x)
    x[2] <- 7L
    address(x)

必须高度重视上述行为，因为它具有重要的性能影响。

如果有其他参数，放在``x``和``value``之间：

    `modify<-` <- function(x, position, value) {
      x[position] <- value
      x
    }
    modify(x, 1) <- 10    # turned into: x <- `modify<-`(x, 1, 10)
    x

replacement可以与subsetting一起使用：

    x <- c(a=1, b=2, c=3)
    names(x)
    names(x)[2] <- 'two'
    names(x)

其中，实际上创建了一个临时变量：
    
    `*tmp*` <- names(x)
    `*tmp*`[2] <- 'two'
    names(x) <- `*tmp*`

