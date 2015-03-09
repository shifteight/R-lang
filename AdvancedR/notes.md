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

# OO指南
本章需要用pryr包。

## 基本类型
每个R对象底层是一个C结构（struct），该struct描述对象在内存中存储情况。

## S3
S3是最早及最简单的OO系统，base和stat包仅包含这种OO系统，在CRAN中使用最多。S3是非正式但小巧精致。R中多数对象都是S3对象，但判别一个对象是否S3对象却不那么容易，一般你只能用``is.object(x) & !isS4(x)``来判断``x``是一个对象但非S4对象。更容易的方法是使用``pryr::otype()``：

    df <- data.frame(x=1:10, y=letters[1:10])
    otype(df)    # a data frame is an S3 class
    otype(df$x)  # a numeric vector isn't
    otype(df$y)  # a factor is

S3中，方法隶属于泛型函数（generic functions），或简称泛型（generics）。S3方法不属于对象或是类，这点与很多OO语言不同。

为了判别某个函数是否S3泛型，可查看源代码中是否包含``UseMethod()``，该函数负责选择正确的方法调用，这就是所谓的方法分派（method dispatch）。也可以用``pryr::ftype()``来判断函数的类型。

某些S3泛型，比如``[``、``sum()``、``cbind()``，不调用``UseMethod()``，因为它们是用C实现的，调用``DispatchGroup()``或``DispatchOrEval()``函数。采用C方法分派的函数称为内部泛型（internal generics），可用``?"internal generic"``或``pryr::ftype()``查看。

给定一个类，S3泛型的任务是负责调用正确的S3方法。可以通过名称来识别S3方法，一般形式为``generic.class()``。比如，均值泛型``mean()``的Date方法为``mean.Date()``，``print()``的factor方法为``print.factor()``。正由于这个特征，现代风格不鼓励函数名中使用`.`。``methods()``返回某个泛型的所有方法。多数base包之外的S3方法都是不可见的（non-visible），可以用``getS3method()``查看其源代码。也可列出拥有某个给定类的方法的所有泛型：``methods(class='ts')``。

创建S3对象并定义相应类有两种方法：一种是直接用``structure()``或者建立对象后用``class<-()``。S3对象通常建立在列表或带属性的原子向量上。也可将函数转化为S3对象。``class()``给出某个对象的类，``inherits()``判断某个对象是否继承自某个类。

S3对象的类可以是一个向量，比如，``glm()``对象的类是``c("glm", "lm")``，表明广义线性模型继承自线性模型。类名称通常小写。

多数S3类提供一个构造函数，比如：

    foo <- function(x) {
      if (!is.numeric(x)) stop("X must be numeric")
      structure(list(x), class='foo')
    }
    
尽可能地使用构造函数，确保创建类包含正确的组件。构造函数通常与类同名。除了开发者提供的构造函数，S3并不检测其正确性，这意味着你可以改变已有对象的类。

构建一个新的泛型，只要创建一个调用``UseMethod()``的函数，包括两个参数：一个作为泛型的名称，一个用于方法分派。不要向``UseMethod()``传递任何参数。比如：

    f <- function(x) UseMethod("f")
    
泛型只有添加了方法才有用，添加的方法具有``generic.class``形式：
    
    f.a <- function(x) "Class a"
    
    a <- structure(list(), class="a")
    class(a)
    f(a)

为已有泛型函数添加方法也一样：

    mean.a <- function(x) "a"
    mean(a)    #> [1] "a"

可以发现，R并不检查方法是否返回与泛型兼容的类。

S3方法分派比较简单。``UseMethod()``创建一个包含函数名称的向量，就像``paste0('generic', '.', c(class(x), 'default'))``，接着按顺序查找。``default``类作为fallback。

    f <- function(x) UseMethod("f")
    f.a <- function(x) "Class a"
    f.default <- function(x) "Unknown class"
    
    f(structure(list(), class = "a"))
    #> [1] "Class a"
    # No method for b class, so uses method for a class
    f(structure(list(), class = c("b", "a")))
    #> [1] "Class a"
    # No method for c class, so falls back to default
    f(structure(list(), class = "c"))
    #> [1] "Unknown class"
  
组泛型（group generics）有点复杂。四类组泛型如下：

- Math: abs, sign, sqrt, floor, cos, sin, log, exp, …
- Ops: +, -, *, /, ^, %%, %/%, &, |, !, ==, !=, <, <=, >=, >
- Summary: all, any, sum, prod, min, max, range
- Complex: Arg, Conj, Im, Mod, Re

查看``?groupGeneric``获取更多细节。最重要的一点是，上面的Math、Ops、Summary、Complex不是真正的函数，而是代表一组函数（函数组）。组泛型中有个特殊变量``.Generic``给出了真正调用的广义函数。

当类层次较复杂时，经常需要调用父方法（parent method），参考``?NextMethod``。

注1: UseMethod() calls methods in a special way.
    
    y <-1
    g <- function(x) {
      y <- 2
      UseMethod("g")
    }
    g.numeric <- function(x) y
    g(10)  #> [1] 2
    
    h <- function(x) {
      x <- 10
      UseMethod("h")
    }
    h.character <- function(x) paste("char", x)
    h.numeric <- function(x) paste("num", x)
    h("a")  #> [1] "char a"

注2： Internal generics don’t dispatch on the implicit class of base types.
    
    f <- function() 1
    g <- function() 2
    class(g) <- "function"
    
    class(f)
    class(g)
    
    length.function <- function(x) "function"
    length(f)
    length(g)
## S4
识别S4对象、泛型和方法比较容易：对于S4对象，``str()``返回“formal” class，``isS4()``返回``TRUE``，``pryr::otype()``返回``S4``；S4泛型和方法就是定义了类的S4对象。``stats4``包提供了S4类。

    # From example(mle)
    y <- c(26, 17, 13, 12, 20, 5, 9, 8, 5, 4, 8)
    nLL <- function(lambda) - sum(dpois(y, lambda, log = TRUE))
    fit <- mle(nLL, start = list(lambda = 5), nobs = length(y))
    
    # An S4 object
    isS4(fit)
    otype(fit)
    
    # An S4 generic
    isS4(nobs)
    ftype(nobs)
    
    # Retrieve an S4 method
    mle_nobs <- method_from_call(nobs(fit))
    isS4(mle_nobs)
    ftype(mle_nobs)

使用``is()``带一个参数，列出某个对象继承的所有类；带两个参数，测试某个对象是否继承自某个类。

    is(fit)
    is(fit, "mle")

可以用``getGenerics()``获得所有S4泛型的列表，用``getClasses()``返回所有S4类。``showMethods()``列出所有S4方法（可用``generic``或``class``限制输出。也可以用``where=search()``限制搜索范围。

S3中可通过设定class属性将某个对象转化为某个特定类的对象，而在S4中则更加严格：必须用``setClass()``定义一个类的表示，然后用``new()``创建新对象。查询类文档用下面的特殊语法：``class?className``，比如，``class?mle``。

S4类具有三个关键性质：

- 名称（name）：alpha-numeric，UpperCamelCase 
- 槽（named slots）的命名列表，槽也叫域（fields）：定义了槽的名称和允许的类。比如，一个person类：``list(name="character", age="numeric")``
- contains：一个表示继承（包含）关系的字符串

在``slots``和``contains``中可以使用S4类、用``setOldClass()``注册过的S3类或基本类型的隐含类。此外，在``slots``中可以使用特殊类``ANY``，即对输入不加限制。

S4类的其他性质包括：``validity``方法，``prototype``对象，``?setClass``有更多细节。

    ＃ Create S4 classes and objects
    setClass("Person",
             slots = list(name = "character", age = "numeric"))
    setClass("Employee",
             slots = list(boss = "Person"),
             contains = "Person")
    
    alice <- new("Person", name = "Alice", age = 40)
    john <- new("Employee", name = "John", age = 20, boss = alice)

注：多数S4类带有一个同名构造函数，如果有，就用它取代``new()``创建对象。

``@``（相当于``$``）或``slot()``（相当于``[[``），用于获取S4对象的槽：比如，``alice@age``或``slot(john, "boss")``。

如果某个S4对象继承自S3类或基本类型，它将具有一个特殊的``.Data``槽，其中包含背后的基本类型或S3对象。比如：

    setClass("RangedNumeric",
             contains="numeric",
             slots=list(min="numeric", max="numeric"))
    rn <- new("RangedNumeric", 1:10, min=1, max=10)
    rn@min
    rn@.Data

S4提供了一些特殊函数，用来创建新的泛型和方法。``setGeneric()``创建一个新泛型或者将已有函数转化为泛型。``setMethod()``具有三个参数：泛型名，与方法关联的类，以及实现方法的函数。比如，可以让``union()``适用于data frame：

    # Make union() work with data frames
    setGeneric("union")
    setMethod("union",
              c(x="data.frame", y="data.frame"),
              function(x, y) {
                unique(rbind(x, y))
              }
    )

如果要从头开始创建泛型，需要提供一个调用``standardGeneric()``的函数：

    setGeneric("myGeneric", function(x) {
      standardGeneric("myGeneric")
    })

其中，``standardGeneric()``相当于S3中的``UseMethod()``。

如果S4泛型在单个具有单父类的类上进行分派，则分派机制与S3一样。主要区别在于如何设定缺省值：S4使用特殊类``ANY``匹配任何类，使用"missing"匹配缺失参数。与S3类似，S4也有组泛型，也可用``callNextMethod()``调用父方法。多参数或多继承情形下的分派机制要复杂得多，参考``?Methods``。最后，有两个方法来判断那个方法被调用了：

    # From methods: takes generic name and class names
    selectMethod("nobs", list("mle"))
    
    # From pryr: takes an unevaluated function call
    method_from_call(nobs(fit))

## RC
引用类是R中最新的OO系统（2.12版引入）。RC与S3和S4有本质不同：

- RC方法属于对象，而不是函数；
- RC对象是可修改的：通常的copy-on-modify语义不适用。

这些特点使得RC与其他OO语言更加接近。RC是用R代码实现的，就是一个特定S4类。

创建一个RC类，使用``setRefClass()``，第一个（必需的）参数是name（alphanumeric）。你可以使用``new()``创建新的RC对象，但更好的风格是用``setRefClass()``返回的对象来生成新的对象。

    Account <- setRefClass("Account")
    Account$new()

``setRefClass()``也接受一个name-class对的列表，该列表定义了类的域（fields），``new()``的额外参数给定域的初始值。``$``获取和设定域的值：

    Account <- setRefClass("Account",
                           fields=list(balance="numeric"))
    a <- Account$new(balance=100)
    a$balance
    a$balance <- 200
    a$balance

RC对象是可修改的，具有引用语义，因此，RC对象带有一个``copy()``方法：

     c <- a$copy()
     c$balance    # 0
     a$balance <- 100
     c$balance    # 0, no change

RC方法与某个类关联并可以修改类的域（使用``<<-``，in place）。

    Account <- setRefClass("Account",
                           fields = list(balance = "numeric"),
                           methods = list(
                             withdraw = function(x) {
                               balance <<- balance - x
                             },
                             deposit = function(x) {
                               balance <<- balance + x
                             }
                           )
    )
    
    a <- Account$new(balance = 100)
    a$deposit(100)
    a$balance

``setRefClass()``还有一个重要参数是``contains``，表示继承的父类。下面创建一种不能透支的银行账户（作为Account的子类）。

    NoOverdraft <- setRefClass("NoOverdraft",
                               contains = "Account",
                               methods = list(
                                 withdraw = function(x) {
                                   if (balance < x) stop("Not enough money")
                                   balance <<- balance - x
                                 }
                               )
    )
    accountJohn <- NoOverdraft$new(balance = 100)
    accountJohn$deposit(50)
    accountJohn$balance
    #> [1] 150
    accountJohn$withdraw(200)
    #> Error in accountJohn$withdraw(200): Not enough money

所有的引用类都继承自``envRefClass``。该类提供了一些有用的方法：copy，callSuper, field, export, show, 等等。

## 选择哪个系统？
一般R编程S3就足够了。S4提供了更复杂的面向对象编程（Matrix包是绝佳范例）。RC类只有当确实需要可修改状态时使用。

# 环境
所谓环境（environment），就是提供作用域的数据结构。环境具有引用语义，即会被in place修改。

## 基础知识
环境将一系列名称与一系列值绑定。环境可以想象成一个名称的包裹。其中，每个名称指向存储在内存其他地方的某个对象。对象不在环境中，因此，多个名称可以指向同一个对象。如果某个对象没有名称指向它，将被垃圾收集器自动删除。

每个环境都有一个父环境。父环境用来实现词法作用域：如果某个名称在一个环境中找不到，R将去其父环境查找，如此继续下去。只有一个环境没有父环境：空（empty）环境。

通常情况下，环境与列表类似，有四个例外：

- 环境中每个对象都有唯一名称；
- 环境中的对象没有顺序；
- 环境有parent；
- 环境具有引用语义。

技术上说，环境由frame和父环境两个部分组成。其中，frame包含名称－对象绑定（与named list类似）。但frame在R中的使用并不保持一致，比如，``parent.frame()``并不给出环境的parent frame，而是给出调用（calling）环境。

有四个特殊的环境：

- globalenv()，全局环境，即交互式工作空间。全局环境的父环境是加载的最后一个包；
- baseenv()，基本环境，即base包的环境，其父环境是空环境；
- emptyenv()，空环境，是所有环境的终极祖先，唯一一个没有父环境的环境；
- environment()，表示当前环境。

``search()``列出全局环境的所有父环境，称为搜索路径（search path）。它包含所有加载的包和对象对应的环境，也包含一个特殊的环境``Autoloads``，用于在需要时加载（一般较大的）对象（节约内存）。

可以用``as.environment()``访问搜索列表中的任意环境：

    search()
    as.environment("package:stats")

几个环境的关系如下：``globalenv()`` --> The search path --> ``baseenv()`` --> ``emptyenv()``。

用``ls()``可以列出环境中所有绑定，默认不列出以`.`开头的名称，加上``all.names=TRUE``将列出所有绑定。``parent.env()``给出父环境。``ls.str()``给出环境中的每个对象。``$``、``[[``、``get()``用来获取某个绑定的值，其中前两个只在一个环境中查找，如果没有绑定，返回NULL，后一个使用通常的作用域规则，如果没有绑定，则报错。移除绑定使用``rm()``。判断某个绑定是否存在用``exists()``，与``get()``类似，默认情况下遵循通常的作用域规则，并会查找父环境（若不需要这种行为，可以加上``inherits=FALSE``参数）。比较环境，用``identical()``（不能用``==``）。

## 环境上的递归
环境就是一个树结构，因此写递归很容易。``pryr::where()``用来查找某个名称是哪个环境定义的，其源代码如下：

    where <- function(name, env = parent.frame()) {
      if (identical(env, emptyenv())) {
        # Base case
        stop("Can't find ", name, call. = FALSE)
        
      } else if (exists(name, envir = env, inherits = FALSE)) {
        # Success case
        env
        
      } else {
        # Recursive case
        where(name, parent.env(env))
        
      }
    }

``where``函数提供了一个写递归函数的模板：

    f <- function(..., env = parent.frame()) {
      if (identical(env, emptyenv())) {
        # base case
      } else if (success) {
        # success case
      } else {
        # recursive case
        f(..., env = parent.env(env))
      }
    }

## 函数环境
多数环境不是用户用``new.env()``创建的，而是使用函数时创建的。与函数相关的环境有四类：

- 包含（enclosing）环境：函数创建时的环境，有且仅有一个
- 绑定（binding）环境：用``<-``绑定函数至名称时定义的环境
- 执行（execution）环境：调用函数时创建的临时环境，用于保存执行过程中欧给你的变量
- 调用（calling）环境：每一个执行环境关联一个调用环境，用于说明函数在哪里被调用

对于后三种类型，每个函数可以关联0，1或多个环境。

``environment()``返回函数的包含环境。有时，包含环境和绑定环境是一样的，但当你重新绑定函数时，绑定环境可能发生变化；包含环境从属于函数，即使函数移动到另一个环境，它的包含环境也不会改变。总之，包含环境决定了函数如何寻找值，而绑定环境决定了我们如何寻找函数。两者的区别对于包名称空间非常重要。比如，假定包A用到base包的``mean()``函数，而包B创建了自己的``mean()``函数，会发生什么？名称空间能保证包A继续使用base包的mean，而不受包B的影响。名称空间是用环境实现的，基于这样一个事实：函数并不存在在于其包含环境中。以base包的``sd``函数为例，其绑定环境和包含环境是不一样的：

    environment(sd)
    where("sd")

``sd()``函数定义用到``var()``函数，但如果我们创建一个新的``var()``函数，对``sd()``并无影响。其中的机理如下：每个package都有两个环境与之关联，一个package环境，一个namespace环境。package环境包含所有公有函数，置于搜索路径之上；namespace环境包含所有的函数（包括内置函数），其父环境是一个特殊的imports环境（包含包所需函数的绑定）。包的每个输出函数绑定（bound）至package环境，但包含（enclosed）在namespace环境。

函数的执行环境是临时的，函数返回时，执行环境消失。当在一个函数中调用另一个函数，子函数的包含环境就是父函数的执行环境，且该执行环境不再是临时的。下面给出一个函数工厂（factory）的例子：

    plus <- function(x) {
      function(y) x + y
    }
    plus_one <- plus(1)
    identical(parent.env(environment(plus_one)), environment(plus))
    #> [1] TRUE

``parent.frame()``（这个名字起得不好）得到函数的调用环境。下面的代码分别获取两个不同的``x``：

    f <- function() {
      x <- 10
      function() {
        def <- get("x", environment())
        cll <- get("x", parent.frame())
        list(defined = def, called = cll)
      }
    }
    g <- f()
    x <- 20
    str(g())
    #> List of 2
    #>  $ defined: num 10
    #>  $ called : num 20

更复杂的情况下，可能不止一个父调用，而是一系列调用串联至从顶层调用的初始函数。下面的例子给出三层call stack

    x <- 0
    y <- 10
    f <- function() {
      x <- 1
      g()
    }
    g <- function() {
      x <- 2
      h()
    }
    h <- function() {
      x <- 3
      x + y
    }
    f()
    #> [1] 13

注意每个执行环境有两个父环境：一个calling环境和一个enclosing环境。R通常的作用域规则只使用enclosing环境；``parent.frame()``允许你访问calling parent。在calling环境而不是enclosing环境查找变量，成为动态作用域（dynamic scoping）（详见“非标准求值”部分）。

## 名称绑定
常规赋值``<-``总是在当前环境中创建一个变量。深赋值``<<-``从不在当前环境中创建变量，而是修改一个已有的变量（向父环境追溯）。深绑定也可用``assign()``，实际上，``<<-``就相当于``assign("name", value, inherits=TRUE)``。``<<-``常常与闭包一起使用。还有两类特殊绑定，延迟（delayed）绑定和活跃（active）绑定：

- delayed binding：创建并保存一个promise，在需要时求值。可以用``pryr``包的``%<d-%``赋值符创建延迟绑定（``%<d-%`` is a wrapper around the base ``deayledAssign()`` function）。
- active binding：绑定的不是常对象，每次被访问时都将重新求值。可以用``pryr``包的``%<a-%``创建（``%<a-%`` is a wrapper for ``makeActiveBinding()``）。

## 显式环境
除了提供作用域规则，环境本身也是非常有用的数据结构，因为它们具有引用语义。看下面的函数：

    modify <- function(x) {
      x$a <- 2
      invisible()
    }

如果将``modify()``应用于列表，原有的列表不被修改；但如果应用于环境，就会修改原环境：

    x_e <- new.env()
    x_e$a <- 1
    modify(x_e)
    x_e$a
    #> [1] 2


