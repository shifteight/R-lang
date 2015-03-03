# 数据结构

## 向量


## 属性

所有的对象都可以添加任意的属性（attributes），这些属性用来存储关于对象的元数据（metadata）。属性可以想象为命名列表（named list）（其中names都是唯一的）。属性可以通过attr()逐个获取，也可以用attributes()一次全部获取。

	y <- 1:10
	attr(y, "my_attribute") <- "This is a vector"
	attr(y, "my_attribute")
	#> [1] "This is a vector"
	str(attributes(y))
	#> List of 1
	#> $ my_attribute: chr "This is a vector"

structure()函数返回一个带有修改后属性的新对象：

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

这三个属性都具有各自的读取函数，分别是names(), dim(), class()，不要用attr(,'names')等。

## 矩阵与数组
矩阵和数组分别由 matrix()和array()构建，或者从dim()的赋值形式构建：
	
	

## 数据框
数据框（data frame）是等长向量的列表，它既有matrix的性质，也有list的性质。

# 取子集

- 三种子集选取操作符
- 六类选取方式
- 不同类型对象子集选取的区别
- 取子集与赋值结合使用