#MySQL必知必会
## 前言
SQL必知必会中重复的内容就不再出现了，重点在MySQL中的内容。
## Chapter 9 正则表达式
### 9.1 正则表达式是用来匹配文本的特殊的串（字符集合），用正则表达式语言来建立。
> **正则表达式（regular expression）**
> 简写为regexp。

### 9.2 使用MySQL正则表达式
#### 9.2.1基本字符匹配
检索列prod_name包含文本1000的所有行：
```
SELECT prod_name
FROM products
WHERE prod_name REGEXP '1000'
ORDER BY prod_name;
```

REGEXP后面所跟的内容作为正则表达式处理。  
.是正则表达式语句中一个特殊字符，表示匹配任意一个字符。
#### 9.2.2 进行OR匹配
搜索两个串之一：
```
SELECT prod_name
FROM products
WHERE prod_name REGEXP '1000|2000'
ORDER BY prod_name;
```

|字符相当于SELECT语句中使用OR语句。
#### 9.2.3 匹配几个字符之一
通过指定一组用[]括起来的字符实现匹配特定字符：
```
SELECT prod_name
FROM products
WHERE prod_name REGEXP '[123] Ton'
ORDER BY prod_name;
```

[]是另一种OR语句。
#### 9.2.4 匹配范围
用-来定义一个范围：
```
SELECT prod_name
FROM products
WHERE prod_name REGEXP '[1-5] Ton'
ORDER BY prod_name;
```

#### 9.2.5 匹配特殊字符
为了匹配特殊字符，必须使用\\作为前导：
```
SELECT vend_name
FROM Vendors
WHERE vend_name REGEXP '\\.'
ORDER BY vend_name;
```

> 这种处理叫做转义，其他转义还有\\\f换页，\\\n换行，\\\r回车，\\\t制表，\\v纵向制表。

#### 9.2.6 匹配字符类
预定义的字符集称为字符类。
#### 9.2.7 匹配多个实例
利用正则表达式重复元字符：
```
SELECT prod_name
FROM products
WHERE prod_name REGEXP '\\([0-9] sticks?\\)'
ORDER BY prod_name;
```

说明：\\(匹配\\)，[0-9]匹配任意数字，sticks?匹配stick和sticks。  
*：0个或多个匹配  
+：1个或多个匹配  
?：0个或1个匹配  
{n}：指定数目的匹配  
{n,}：不少于指定数目的匹配  
{n，m}：匹配数目的范围  
匹配连在一起的4位数字：
```
SELECT prod_name
FROM products
WHERE prod_name REGEXP '[[:digit:]]{4}'#{4}要求前面的字符出现4次
#WHERE prod_name REGEXP '[0-9][0-9][0-9][0-9]'
ORDER BY prod_name;
```

#### 9.2.8 定位符
^：文本的开始  
$：文本的结尾  
[[:<:]]：词的开始  
[[:>:]]：词的结尾  
检索以数（包括小数点开始的数）开始的所有产品：
```
SELECT prod_name
FROM products
WHERE prod_name REGEXP '^[0-9\\.]'
ORDER BY prod_name;
```


