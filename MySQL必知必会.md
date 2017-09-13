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
#### 匹配范围
用-来定义一个范围：
```
SELECT prod_name
FROM products
WHERE prod_name REGEXP '[1-5] Ton'
ORDER BY prod_name;
```

#### 匹配特殊字符
为了匹配特殊字符，必须使用\\作为前导：
```
SELECT vend_name
FROM Vendors
WHERE vend_name REGEXP '\\.'
ORDER BY vend_name;
```

> 这种处理叫做转义，其他转义还有\\\f换页，\\\n换行，\\\r回车，\\\t制表，\\v纵向制表。

