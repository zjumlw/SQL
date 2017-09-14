# MySQL必知必会
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

## Chapter 18 全文本搜索
### 18.1 理解全文本搜索
LIKE和正则表达式很有用，但是有几个重要的限制：
- 性能：通配符和正则表达式匹配通常要求MySQL常识匹配表中所有行，非常耗时。
- 明确控制：使用通配符和正则表达式很难明确地控制匹配什么和不匹配什么。
- 智能化的结果：使用通配符和正则表达式都不能提供一种智能化的选择结果的方法。

### 18.2 使用全文本搜索
#### 18.2.1 启用全文本搜索支持
CREATE TABLE语句接受FULLTEXT子句，它给出被索引列的一个逗号分隔的列表。
```
CREATE TABLE productnotes
(
  note_id    int           NOT NULL AUTO_INCREMENT,
  prod_id    char(10)      NOT NULL,
  note_date datetime       NOT NULL,
  note_text  text          NULL ,
  PRIMARY KEY(note_id),
  FULLTEXT(note_text)
) ENGINE=MyISAM;
```

这里MySQL根据子句FULLTEXT(note_text)的指示对列note_text进行索引，如果需要也可以指定多个列。  
在定义之后，MySQL自动维护该索引，在增加、更新或删除行时，索引随之自动更新。  
可以在创建表时指定FULLTEXT，或在稍后指定。

> **不要在导入数据时使用FULLTEXT**
> 应该首先导入所有数据，然后在修改表，定义FULLTEXT。这样有助于更快地导入数据。

#### 18.2.2 进行全文本搜索
使用函数Match()和Against()执行全文本搜索，其中Match()指定被搜索的列，Against()指定要使用的搜索表达式：
```
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('rabbit');
```

Match(note_text)指示MySQL针对指定的列进行搜索，Against('rabbit')指定rabbit作为搜索文本。

> **Match()使用说明**
> 传递给Match()的值必须与FULLTEXT()定义中的相同，如果指定多个列，则必须列出它们。
> **搜索不区分大小写**
> 除非使用BINARY方式，否则全文本搜索不区分大小写。

也可以使用LIKE子句完成：
```
SELECT note_text
FROM productnotes
WHERE note_text LIKE '%rabbit%';
```

虽然都能返回结果，但是全文本搜索的一个重要部分就是对结果排序，具有哦较高等级的行先返回。

> **搜索多个搜索项**
> 如果指定多个搜索项，则包含多数匹配词的那些行具有比包含较少词的那些行搞的等级值。

#### 18.2.3 使用查询扩展
查询扩展用来设法放宽所返回的全文本搜索结果的范围。在使用查询扩展时，MySQL对数据和索引进行两边扫描来完成搜索：
- 进行一个基本的全文本搜索，找出与搜索条件匹配的所有行；
- MySQL检查这些匹配行并选择所有有用的词；
- MySQL再次进行全文本搜索，不仅使用原来的条件，还使用所有有用的词。

首先是简单的全文本搜索：
```
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('anvils');
```

然后是使用查询扩展：
```
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('anvils' WITH QUERY EXPANSION);
```

#### 18.2.4 布尔文本搜索
布尔文本搜索：
- 要匹配的词；
- 要排斥的词；
- 排列提示；
- 表达式分组；
- 另外一些内容。

```
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('heavy -rope*' IN BOOLEAN MODE);
```

其中有相关的全文本布尔操作符。

> 没有FULLTEXT也可以使用，但是速度很慢。

#### 18.2.5 全文本搜索的使用说明
说明：
- 索引全文本数据时，短词被忽略且从索引中排除；
- MySQL带有一个内建的非用词（stopword）列表，这些词在索引全文本数据时总是被忽略，如果需要可以覆盖这个列表；
- MySQL有一个50%规则，如果一个词出现50%以上，则将它作为一个非用词忽略。该规则不适用于IN BOOLEAN MODE；
- 如果表中的行少于3行，则全文本搜索不返回结果；
- 忽略词中的单引号；
- 不具有词分隔符的语言不能恰当地返回全文本搜索结果。




