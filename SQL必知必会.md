# SQL必知必会  
## Chapter 1 了解SQL  
### 1.1 数据库基础
数据库就是一个以某种有组织的方式存储的数据集合。
> **数据库（database）**  
> 保存有组织的数据的容器（通常是一个文件或一组文件）。  
> 数据库是通过数据库管理软件（DBMS）创建和操纵的容器。   

表是一种结构化的文件，用来存储某种特定类型的数据。可以保存顾客清单、产品目录或者其他清单。
>**表（table）**  
>某种特定类型数据的结构化清单。

存储在表中的数据一定是同一种类型的数据或者清单。
每个表拥有一个名字来标识自己，叫做表名。
>在相同的数据库中不能两次使用相同的表名，在不同的数据库中可以使用相同的表名。  

模式用来描述表的一些特性，包含存储什么样的数据，数据如何分解，各部分信息如何命名等信息。  
>**模式（schema）**  
>关于数据库和表的布局及其特性的信息。  

表由列组成。
>**列（column）**  
>表中的一个字段，所有表都是由一个或多个列组成。  

数据库中每个列都有相应的数据类型，限制或允许该列中存储的数据，帮助正确的分类数据，优化磁盘。  
表中的数据是按行存储的，每个记录存储在自己的行内，表中的行编号为记录的编号。
>**行（row）**  
>表中的一个记录，也被成为数据库记录（record）。  

可以唯一标识自己的列，称为主键。
>**主键（primary key）**  
>一列或多列，其值可以唯一标识表中的每一行。  

主键应该满足的条件：  

- 任意两行都不具有相同的主键值；  
- 每一行都必须具有一个主键值（不允许null值）；
- 主键列中的值不允许修改或更新；
- 主键值不能重用（如果某行被删除，它的主键不能赋给以后的新行）。

### 1.2什么是SQL  
SQL（Structured Query Language），专门用来与数据库沟通的语言。设计SQL的目的是很好地完成一项任务--提供一种从数据库中读写数据的简单有效的方法。  
SQL的优点：  

- 不是某个特定数据库供应商专有的语言，具有通用性；  
- 简单易学；  
- 灵活使用其语言元素，可以进行非常复杂和高级的数据库操作。 
 
## Chapter 2 检索数据  
### 2.1 SELECT语句  
SQL语句由关键字构成，最常用的是SELECT语句。
>**关键字（keyword）**  
>作为SQL组成部分的保留字，不能用作表或列的名字。  

使用SELECT检索表数据，至少需要给出两条信息：1.想选择什么，2.从什么地方选择。  
### 2.2 检索单个列
使用SELECT：
```
SELECT prod_name 
FROM Products;
```  
>多条SQL语句必须以分号分隔；  
>SQL语句不区分大小写，表名、列名和值可能区分大小写；  
>所有的空格都被忽略，可以写在一行也可以分行。  

### 2.3 检索多个列  
在select关键字后面给出多个列名，列名之间用逗号分隔：
```
SELECT prod_id, prod_name, prod_price
FROM Products;
```  
### 2.4 检索所有列  
在实际列名的位置用星号代替：  
``` 
SELECT *  
FROM Products;
```  

> 使用星号通配符可以检索出名字未知的列。  

### 2.5 检索不同的值  
使用关键字DISTINCT（DISTINCT必须放在列名的前面）：  
```
SELECT DISTINCT vend_id
FROM Products;
```  
### 2.6 限制结果  
只检索前5行，在MySQL中的实现：
```
SELECT prod_name  
FROM Products  
LIMIT 5;
```  
检索第5行开始的前5行，在MySQL中的实现：
```
SELECT prod_name  
FROM Products  
LIMIT 5 OFFSET 5;
```  
> 第一个被检索的是第0行而不是第1行，因此LIMIT 1 OFFSET 1会检索第2行而不是第一行。  
> 在MySQL中，LIMIT 3，4 == LIMIT 4 OFFSET 3  


### 2.7 使用注释  
行内注释：
```
/*来一条注释
*/
SELECT prod_name
FROM Products;
#这是一条注释
```  
## Chapter 3 排序检索数据  
### 3.1 排序数据  
如果不明确规定排序顺序，则不应该假定检索出的数据的顺序有任何意义。
>**子句（clause）**  
>一个子句由*1个*关键字和提供的数据组成。

使用ORDER BY子句对输出按照字母顺序进行排序：
```
SELECT prod_name
FROM Products
ORDER BY prod_name;
```  

这里应保证ORDER BY子句是SELECT语句中的最后一条子句，否则会出现错误。  
### 3.2 按多个列排序  
指定列名，列名之间用逗号分开即可。以下首先按价格，然后按名称排序：
```
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY prod_price, prod_name;
```
### 3.3 按列位置排序  
ORDER BY支持按相对列位置进行排序：
```
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY 2, 3;
```  
得到的结果与上一个命令一样，好处在于不用重新输入列名，缺点有：1.不明确给出列名可能造成错误；2.对SELECT清单进行更改会影响数据排序；3.如果进行排序的列不在SELECT清单中，不能使用这项技术。  
### 3.4 指定排序方向  
降序排序使用关键字DESC：
```
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY prod_price DESC;
```  
DESC关键字只应用到直接位于其前面的列名：
```
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY prod_price DESC, prod_name;
```  
这里先按照price降序，再按照name升序。  
## Chapter 4 过滤数据  
### 4.1 使用WHERE子句  
检索所需数据需要指定搜索条件（过滤条件），数据根据WHERE子句中指定的搜索条件进行过滤，WHERE子句在表名（FROM子句）之后给出：
```
SELECT prod_name, prod_price
FROM Products
WHERE prod_price = 3.49;
```  
> 在同时使用ORDER BY和WHERE子句时，应该让ORDER BY位于WHERE之后，否则会产生错误。 

### 4.2 WHERE子句操作符  
大于 小于 等于 不等于 不大于 不小于 大于等于 小于等于 两者之间（BETWEEN） 为NULL值（IS NULL）  
> 单引号用来限定字符串，数值不需要用引号。  

使用BETWEEN必须指定两个值，低值和高值，并且用AND关键字分隔：
```
SELECT prod_name, prod_price
FROM Products
WHERE prod_price BETWEEN 5 AND 10;
```  
BETWEEN匹配范围内所有值，包括边界值。
在一个列不包含值时，称其包含空值NULL。
> **NULL**  
> 无值（no value），与字段包含0、空字符串或者空格不同。

检查空值用IS NULL子句：  
```
SELECT cust_name
FROM Customers
WHERE cust_email IS NULL;
```  
## Chapter 5 高级数据过滤  
### 5.1 组合WHERE子句  
SQL允许给出多个WHERE子句，以AND子句或者OR子句的方式使用。
> **操作符（operator）**  
> 用来联结或改变WHERE子句中的子句的关键字，也称为逻辑操作符（logical operator）。

通过AND操作符给WHERE子句附加条件实现对不止一个列进行过滤：
```
SELECT prod_id, prod_price, prod_name
FROM Products
WHERE vend_id = 'DLL01' AND prod_price <= 4;
```
通过OR操作符给WHERE子句附加条件实现匹配任一条件的行：
```
SELECT prod_id, prod_price, prod_name
FROM Products
WHERE vend_id = 'DLL01' OR vend_id = 'BRS01';
```  
AND操作符优先级大于OR操作符，可以用圆括号对操作符进行明确分组：
```
SELECT prod_name, prod_price
FROM Products
WHERE (vend_id = 'DLL01' OR vend_id = 'BRS01') 
AND prod_price > 10;
```
### 5.2 IN操作符  
IN操作符用来指定条件范围，范围中的每个条件都可以进行匹配：
```
SELECT prod_name, prod_price
FROM Products
WHERE vend_id IN ('DLL01', 'BRS01')
ORDER BY prod_name;
```  
与OR有相同的功能，有如下优点：


- 更清楚直观；
- 在与AND和OR操作符组合使用IN，求值顺序容易管理；
- IN比OR执行的更快；
- 可以包含其他SELECT语句，能够动态地建立WHERE子句。

### 5.3 NOT操作符  
有且只有一个功能：否定其后所跟的任何条件：
```
SELECT prod_name
FROM Products
WHERE NOT vend_id = 'DLL01'
ORDER BY prod_name;
```  
NOT从不单独使用，用在要过滤的列前，而不是在其后。
> **NOT**  
> WHERE子句中用来否定其后条件的关键字。


与IN操作符联合使用，NOT可以非常简单找出与条件列表不匹配的行。  
## Chapter 6 用通配符进行过滤  
### 6.1 LIKE操作符  
构造通配符搜索模式。
> **通配符（wildcard）**  
> 用来匹配值的一部分的特殊字符。
> **搜索模式（search pattern）**  
> 由字面值、通配符或者两者组合构成的搜索条件。

使用LIKE操作符指示DBMS后面的搜索模式利用通配符而不是简单的相等匹配进行比较。
%通配符：表示任何字符出现任意次数：
```
SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE 'FISH%';
```
以上表示所有以fish开头的产品。
> 通配符%不会匹配NULL。

_通配符：只匹配单个字符，而不是多个字符。
[]通配符：指定一个字符集，必须匹配指定位置的一个字符。（MySQL中不能使用）

### 6.2 使用通配符的技巧
技巧：
- 不要过度使用通配符；
- 尽量不要放在搜索模式的开始处；
- 注意通配符的位置。

## Chapter 7 创建计算字段
### 7.1 计算字段
计算字段并不实际存在与数据表中，是运行时在SELECT语句内创建的。
> **字段（field）**
> 基本上与列（column）的意思相同，经常互换使用，不过数据库列一般称为列，而术语字段通常与计算字段一起使用。


### 7.2 拼接字段
只有数据库知道SELECT语句中哪些列是实际表列，哪些是计算字段；客户端分辨不出来。
> **拼接（concatenate）**
> 将值联结一起构成单个值。

操作符可用加号（+）或者两个竖杠（||），在MySQL中必须使用特殊的函数Concate：
```
SELECT Concat(vend_name,'(',vend_country,')')
FROM Vendors
ORDER BY vend_name;
```
新计算列并没有名字，可以用别名关键字AS赋予名字：
```
SELECT Concat(vend_name,'(',vend_country,')')
       AS vend_title
FROM Vendors
ORDER BY vend_name;
```
> **别名的其他用途**
> 在实际的表列名包含不合法的字符时重新命名它，在原来的名字容易误解时扩充它。别名有时也叫做导出列，意义是一样的。

### 7.3 执行算术计算
对检索出的数据进行算术计算：
```
SELECT prod_id, quantity, item_price, 
	   quantity*item_price AS expanded_price
FROM Orderitems
WHERE order_num = 20008;
```
> 如果省略了FROM子句，SELECT能简单地访问和处理表达式， SELECT 2*3; 将返回6，SELECT Now()；将返回当前日期和时间。


## Chapter 8 使用函数处理数据
### 8.1 函数
不同DBMS的函数语法可能不同，SQL函数不是可移植的。
MySQL中：
1.提取字符串的组成部分，SUBSTRING();
2.数据类型转换，CONVERT();
3.取当前时间，CURDATE()和NOW()。
> 如果使用函数，做好代码注释，以便以后能确切知道所编写的SQL代码的含义。

### 8.2 使用函数
#### 8.2.1 文本处理函数
RTRIM()函数：去除字符串右边的空格。  
LTRIM()函数：去掉字符串左边的空格。  
LOWER()函数：将文本转换为小写。  
UPPER()函数：将文本转换为大写：  
```
SELECT vend_name, UPPER(vend_name) AS vend_name_upcase
FROM Vendors
ORDER BY vend_name;
```

LEFT()函数：返回字符串左边的字符。  
RIGHT()函数：返回字符串右边的字符。  
LENGTH()函数：返回字符串的长度。  
LOCATE()函数：找出串的一个子串。  
SUBSTRING()函数：返回子串的字符。
SOUNDEX()函数：返回字符串的SOUNDEX值。

#### 8.2.2 日期和时间处理函数
日期和时间函数总是用来读取、统计和处理日期和时间，可移植性最差。
MySQL中可以用year()函数来提取日期中的年份：
```
SELECT order_num
FROM Orders
WHERE YEAR(order_date) = 2012;
```
#### 8.2.3 数值处理函数
处理数值数据，主要用于代数、三角或者几何运算。
ABS() 绝对值
COS() 余弦
EXP() 指数
PI()  圆周率
SIN() 正弦
SQRT()平方根
TAN() 正切

## Chapter 9 汇总数据
### 9.1 聚集函数
汇总数据而不用把它们实际检索出来。
- 确定表中行数；
- 获得表中某些行的和；
- 找出表列的最大值、最小值、平均值。

> **聚集函数（aggregate function）**
> 对某些行运行的函数，计算并返回一个值。

AVG() 返回某列的平均值：
```
SELECT AVG(prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';
```
COUNT() 返回某列的行数；
MAX()返回某列的最大值；
MIN()返回某列的最小值；
SUM()返回某列值之和。

> AVG()只能用来确定特定数值列的平均值，而且列名必须作为函数参数给出。为了获取多个列的平均值，必须使用多个AVG()函数。AVG()忽略列值为NULL的行。

COUNT()确定表中行的数目或符合特定条件的行的数目。
对所有行计数：
```
SELECT COUNT(*) AS num_cust
FROM Customers;
```
对有email的行计数：
```
SELECT COUNT(cust_email) AS num_cust
FROM Customers;
```

> 如果指定列名，则COUNT()会忽略指定列的值为NULL的行，如果是COUNT(*)则不忽略。

MAX()返回指定列中的最大值，要指定列名：
```
SELECT MAX(prod_price) AS max_price
FROM Products;
```
MAX()忽略列值为NULL的行。
用于文本数据时，MAX()返回按该列排序后的最后一行。

MIN()返回指定列中的最小值，要指定列名：
```
SELECT MIN(prod_price) AS min_price
FROM Products;
```
MIN()忽略列值为NULL的行。
用于文本数据时，MIN()返回按该列排序后的最前面一行。

SUM()返回求和。
得到所有物品价格之和：
```
SELECT SUM(quantity*item_price) AS total_price
FROM OrderItems
WHERE order_num = 20005;
```

### 9.2 聚集不同值  
- 对所有行执行计算，指定ALL参数或者不指定参数；
- 只包含不同的值，指定DISTINCT参数：

```
SELECT AVG(DISTINCT prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';
```
  
### 9.3 组合聚集函数  
SELECT语句可以根据需要包含多个聚集函数，用逗号隔开：
```
SELECT COUNT(*) AS num_items,
	   MIN(prod_price) AS price_min,
	   MAX(prod_price) AS price_max,
	   AVG(prod_price) AS price_avg
FROM Products;
```
> **取别名**
> 在指定别名包含某个聚集函数的结果时，不应该使用表中实际的列名。

## Chapter 10 分组数据
### 10.1 数据分组
使用分组可以将数据分为多个逻辑组，对每个组进行聚集计算。
### 10.2 创建分组
使用SELECT语句的GROUP BY子句建立：
```
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
GROUP BY vend_id;
```
使用了GROUP BY就不用指定要计算和估值的每个组了，系统会自动完成。
GROUP BY的一些重要规定：
- GROUP BY子句可以包含任意数目的列，因而可以对分组进行嵌套，更细致地进行数据分组；
- 如果在GROUP BY子句嵌套了分组，数据将在最后指定的分组上进行汇总；
- GROUP BY子句中列出的每一列都必须是检索列或有效的表达式；
- 大多数SQL实现不允许GROUP BY列带有长度可变的数据类型；
- 除了聚集计算语句外，SELECT语句中的每一列都必须在GROUP BY子句中给出；
- 如果分组列中包含具有NULL值的行，则NULL将作为一个分组返回，如果列中有多行NULL值，它们将分为一组；
- GROUP BY子句必须出现在WHERE子句之后，ORDER BY子句之前。

可以使用WITH ROLLUP关键字得到汇总信息：
```
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
GROUP BY vend_id WITH ROLLUP;
```


### 10.3 过滤分组
过滤分组规定包括哪些分组，排除哪些分组。
HAVING子句过滤分组，WHERE子句过滤行：
```
SELECT cust_id, COUNT(*) AS orders
FROM Orders
GROUP BY cust_id
HAVING COUNT(*) >=2;
```
这里WHERE子句不起作用，因为过滤是基于分组聚集值，而不是特定行的值。
> **HAVING和WHERE的差别**
> WHERE在分组前进行过滤，HAVING在分组后进行过滤。WHERE排除的行不在分组中。

```
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
WHERE prod_price >=4
GROUP BY vend_id
HAVING COUNT(*) >=2;
```
### 10.4 分组和排序
> **GROUP BY和ORDER BY的区别**  
> GROUP BY：  
> 1.对行分组，但是输出可能不是分组的顺序；  
> 2.只可能使用选择列或表达式列，而且必须使用每个选择列表达式；  
> 3.如果与聚集函数一起使用列，则必须使用。  
> ORDER BY：  
> 1.对产生的输出排序；  
> 2.任意列都可以使用；  
> 3.不一定需要。  


检索包含三个或更多物品的订单号和订单物品的数目，按照订购物品的数目排序输出：
```
SELECT order_num, COUNT(*) AS items
FROM OrderItems
GROUP BY order_num
HAVING COUNT(*) >=3
ORDER BY items, order_num;
```
### 10.5 SELECT子句顺序
SELECT：要返回的列或者表达式  
FROM：从中检索数据的表  
WHERE：行级过滤  
GROUP BY：分组说明  
HAVING：组级过滤  
ORDER BY：输出排序顺序  
LIMIT：要检索的行数

## Chapter 11 使用子查询
### 11.1 子查询
>**查询（query）**
>任何SQL语句都是查询，但此术语一般指SELECT语句。

SQL允许建立子查询，就是嵌套在其他查询中的查询。
### 11.2 利用子查询进行过滤
问题：检索出订购物品RGAN01的所有顾客  
1.检索包含物品RGAN01的所有订单的编号：
```
SELECT order_num
FROM OrderItems
WHERE prod_id = 'RGAN01';
```

得到订单编号是：20007， 20008；
2.检索具有前一步列出的订单编号的所有顾客的ID：
```
SELECT cust_id
FROM Orders
WHERE order_num in(20007, 20008);
```

结合1和2步骤：
```
SELECT cust_id
FROM Orders
WHERE order_num in(SELECT order_num
				   FROM OrderItems
				   WHERE prod_id = 'RGAN01');
```

在SELECT语句中，子查询总是从内向外处理。
3.检索前一步返回的所有顾客ID的顾客信息：
```
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN(SELECT cust_id
FROM Orders
WHERE order_num in(SELECT order_num
				   FROM OrderItems
				   WHERE prod_id = 'RGAN01'));
```

在WHERE子句中使用子查询能够编写出功能很强且很灵活的SQL语句。对于嵌套的子查询的数目没有限制，不过在实际使用时由于性能的限制，不能嵌套太多的子查询。
> 作为子查询的SELECT语句只能查询单列。

### 11.3 作为计算字段使用子查询
问题：显示Customers表中每个顾客的订单总数
1. 从Customers表中检索顾客列表；
2. 对于检索出的每个顾客，统计其在Orders表中的订单数目。

```
SELECT cust_name, cust_state,
		(SELECT COUNT(*)
		FROM Orders
		WHERE Orders.cust_id = Customers.cust_id) AS orders
FROM Customers
ORDER BY cust_name;
```

对Customers表中每个顾客返回三列：cust_name、 cust_state和orders。 orders是计算字段，由圆括号中的子查询建立，该子查询对检索出的每个顾客执行一次。  
其中的WHERE子句，比较Orders表中的cust_id和当前从Customers表中检索的cust_id，如果是相同，则求在Orders表中该cust_id的行数，即订单总数。  

> 在SELECT语句中操作多个表，就应该使用完全限定列名来避免歧义：
> Orders.cust_id和Customers.cust_id。

## Chapter 12 联结表
### 12.1 联结
SQL最强大的功能之一就是能在数据查询的执行中联结（join）表。  
相同的数据出现多次不是好事，关系表的设计就是要把信息分解成多个表，一个数据一个表。各表通过某些共同的值互相关联。  
关系数据可以有效地存储，方便地处理。因此关系数据库的可伸缩性比非关系数据库要好。  
> **可伸缩（scale）**
> 能够适应不断增加的工作量而不失败。

SELECT语句通过联结检索出存储在多个表中的数据。
### 12.2 创建联结
指定要联结的所有表以及关联它们的方式即可：
```
SELECT vend_name, prod_name, prod_price
FROM Vendors, Products
WHERE Vendors.vend_id = Products.vend_id;
```   

这里FROM子句列出了两个表：Vendors和Products，这就是联结的两个表。WHERE子句指示DBMS将Vendors表中的vend_id与Products表中的vend_id匹配起来。  

> **完全限定列名**
> 如果引用一个没有用表名限制的具有歧义的列名，大部分DBMS会返回错误。

在联结两个表时，实际就是将第一个表中的每一行与第二个表中的每一行配对。WHERE子句作为过滤条件，只包含那些匹配给定条件（联结条件）的行。
> **笛卡尔积（cartesian product）**
> 没有联结条件的表关系返回的结果是笛卡尔积，是第一个表的行数乘以第二个表的行数。该联结也成为叉联结（cross join）。

以上的联结称为等值联结（equijoin），也称为内联结（inner join）。可以明确指定联结的类型：
```
SELECT vend_name, prod_name, prod_price
FROM Vendors INNER JOIN Products
ON Vendors.vend_id = Products.vend_id;
```  
得到结果与上个SELECT语句一样。
SELECT语句可以联结多个表，联结的基本规则相同：首先列出所有表，然后定义表之间的关系：
```
SELECT prod_name, vend_name, prod_price, quantity
FROM OrderItems, Products, Vendors
WHERE Products.vend_id = Vendors.vend_id
	AND OrderItems.prod_id = Products.prod_id
	AND order_num = 20007;
```  
这里WHERE子句定义了两个联结条件对于三个表，第三个联结条件用来过滤订单20007中的物品。
> 不要联结不必要的表，联结的表越多，性能下降越厉害。

对于Chapter 11中的子查询，使用联结可以实现相同的功能：
```
SELECT cust_name, cust_contact
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id
	AND OrderItems.order_num = Orders.order_num
	AND prod_id = 'RGAN01';
```  

## Chapter 13 创建高级联结
### 13.1 使用表别名
SQL除了可以给列名和计算字段使用别名，还允许给表名起别名，可以：缩短SQL语句；允许在一条SELECT语句中多次使用相同的表。  
```
SELECT cust_name,cust_contact
FROM Customers AS C, Orders AS O, OrderItems AS OI
WHERE C.cust_id = O.cust_id
	AND OI.order_num = O.order_num
	AND prod_id = 'RGAN01';
```

这里表别名只用于WHERE子句，也可以用于SELECT的列表、ORDER BY子句以及其他语句部分。
### 13.2 使用不同类型的联结
#### 13.2.1 自联结
在一条SELECT语句中不止一次引用相同的表：
```
SELECT cust_id, cust_name, cust_contact
FROM Customers
WHERE cust_name = (SELECT cust_name
					FROM Customers
					WHERE cust_contact = 'Jim Jones');
```

这是利用子查询的做法，还有：
```
SELECT c1.cust_id, c1.cust_name, c1.cust_contact
FROM Customers AS c1, Customers AS c2
WHERE c1.cust_name = c2.cust_name
	AND c2.cust_contact = 'Jim Jones';
```

SELECT语句使用c1前缀明确给出所需列的全名，如果不这样，DBMS将返回错误，因为cust_id, cust_name, cust_contact的列各有两个。WHERE首先联结两个表，然后按照第二个表的cust_contact过滤数据，返回所需的数据。
> **用自联结而不用子查询**
> DBMS处理联结比处理子查询快很多，选择性能更好的。

#### 13.2.2 自然联结
标准的联结返回所有数据，相同的列甚至多次出现。自然联结排除多次出现，使每一列只返回一次。  
自然联结要求只能选择哪些唯一的列，一般通过对一个表使用通配符（SELECT *），而对其他表的列使用明确的子集来完成：
```
SELECT C.*, O.order_num, O.order_date,
	OI.prod_id, OI.quantity, OI.item.price
FROM Customers AS C, Orders AS O, OrderItems AS OI
WHERE C.cust_id = O.cust_id
	AND OI.order_num = O.order_num
	AND prod_id = 'RGAN01';
```

#### 13.2.3 外联结
许多联结将一个表中的行与另一个表中的行相关联，但有时候需要包含没有关联行的那些行，称为外联结。  
内联结：
```
SELECT Customers.cust_id, Orders.order_num
FROM Customers INNER JOIN Orders
ON Customers.cust_id = Orders.cust_id;
```

外联结：
```
SELECT Customers.cust_id, Orders.order_num
FROM Customers LEFT OUTER JOIN Orders
ON Customers.cust_id = Orders.cust_id;
```

外联结可以检索包括没有订单顾客在内的所有顾客。LEFT关键字指定包括其所有行的表。

全联结（MySQL不支持）：
```
SELECT Customers.cust_id, Orders.order_num
FROM Customers FULL OUTER JOIN Orders
ON Customers.cust_id = Orders.cust_id;
```

### 13.3 使用带聚集函数的联结
聚集函数可以和联结一起使用。  
检索所有顾客及每个顾客所下的订单数：
```
SELECT Customers.cust_id, COUNT(Orders.order_num) AS num_ord
FROM Customers INNER JOIN Orders
ON Customers.cust_id = Orders.cust_id
GROUP By Customers.cust_id;
```

还有
```
SELECT Customers.cust_id, COUNT(Orders.order_num) AS num_ord
FROM Customers LEFT OUTER JOIN Orders
ON Customers.cust_id = Orders.cust_id
GROUP By Customers.cust_id;
```

### 13.4 使用联结和联结条件
要点：
- 注意所使用的联结类型。
- 确切的语法查看文档。
- 保证正确的联结条件。
- 应该总是提供联结条件，否则会得出笛卡尔积。
- 在一个联结中可以包含多个表，甚至可以对每个联结采用不同的联结类型。


## Chapter 14 组合查询
### 14.1 组合查询
SQL允许执行多个查询，并将结果作为一个查询结果集返回，称为并（union）或符合查询（compound query）。  
有两种情况需要使用组合查询：
1.在一个查询中从不同的表返回数据结构；
2.对一个表执行多个查询，按一个查询返回结果。

> 任何具有多个WHERE子句的SELECT语句都可以作为一个组合查询。

### 14.2 创建组合查询
#### 14.2.1 使用UNION
给出每条SELECT语句，在各条语句之间放上关键字UNION。
单条语句：
```
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN('IL', 'IN', 'MI');
```

```
SELECT cust_name, cust_contact, cust_email, cust_state
FROM Customers
WHERE cust_name = 'Fun4All';
```

结合两条语句：
```
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN('IL', 'IN', 'MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';
```

DBMS执行这两条SELECT语句，并把输出组合成一个查询结果集。  
如果使用WHERE子句而不是UNION：
```
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN('IL', 'IN', 'MI')
OR cust_name = 'Fun4All';
```

#### 14.2.2 UNION规则
规则：
- UNION必须由两条或两条以上的SELECT语句组成，语句之间用关键字UNION分隔。
- UNION中的每个查询必须包含相同的列、表达式或聚集函数（出现次序可以不同）。
- 列数据类型必须兼容：类型不必完全相同，但必须是DBMS可以隐含转换的类型。

#### 14.2.3 包含或取消重复的行
使用UNION时，重复的行被自动取消。  
可以用UNiON ALL返回所有的匹配行。
> 如果需要每个条件的匹配行全部出现（包括重复行），必须使用UNION ALL而不是WHERE。

#### 14.2.4 对组合查询结果排序
ORDER BY必须位于最后一条SELECT语句之后。
```
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN('IL', 'IN', 'MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All'
ORDER BY cust_name, cust_contact;
```

> UNION可以组合多个表的数据，即使有不匹配列名的表，可以将UNION与别名组合，检索一个结果集。

## Chapter 15 插入数据
### 15.1 数据插入



