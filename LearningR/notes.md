% Learning R: The Data Analysis Workflow
% Kevin Qian
% 2015

# Getting Data

- 访问R包自带的数据集
- 从文本文件导入数据
- 从二进制文件导入数据
- 从网站下载数据
- 从数据库导入数据

## 内置数据集

    data()
    data(package = .packages(TRUE))
    data('kidney', package = 'survival')
    head(kidney)

## 从文本文件读取

常见的存储数据的文本文件格式包括CSV或tab-delimited，XML，JSON和YAML。
