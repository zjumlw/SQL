# SQL必知必会  
## Chapter_1 了解SQL  
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
 
## Chapter_2 检索数据  
### 2.1 SELECT语句  
SQL语句由关键字构成，最常用的是SELECT语句。
>**关键字（keyword）**  
>作为SQL组成部分的保留字，不能用作表或列的名字。  

使用SELECT检索表数据，至少需要给出两条信息：1.想选择什么，2.从什么地方选择。  
### 2.2 检索单个列
使用SELECT
```
SELECT prod_name 
FROM Products;
```  
>多条SQL语句必须以分号分隔；  
>SQL语句不区分大小写，表名、列名和值可能区分大小写；  
>所有的空格都被忽略，可以写在一行也可以分行。  

### 2.3 检索多个列  
在select关键字后面给出多个列名，列名之间用逗号分隔。  
```
SELECT prod_id, prod_name, prod_price
FROM Products;
```  
### 2.4 检索所有列  
在实际列名的位置用星号代替。  
``` 
SELECT *  
FROM Products;
```  

> 使用星号通配符可以检索出名字未知的列。  

### 2.5 检索不同的值  
使用关键字DISTINCT，注：DISTINCT必须放在列名的前面。  
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
## Chapter_3 排序检索数据  
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
ORDER BY支持按相对列位置进行排序。
```
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY 2, 3;
```  
得到的结果与上一个命令一样，好处在于不用重新输入列名，缺点有：1.不明确给出列名可能造成错误；2.对SELECT清单进行更改会影响数据排序；3.如果进行排序的列不在SELECT清单中，不能使用这项技术。  
### 3.4 指定排序方向  
降序排序使用关键字DESC。
```
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY prod_price DESC;
```  
DESC关键字只应用到直接位于其前面的列名。
```
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY prod_price DESC, prod_name;
```  
这里先按照price降序，再按照name升序。  
## Chapter_4 过滤数据  
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

使用BETWEEN必须指定两个值，低值和高值，并且用AND关键字分隔。BETWEEN匹配范围内所有值，包括边界值。
```
SELECT prod_name, prod_price
FROM Products
WHERE prod_price BETWEEN 5 AND 10;
```  
在一个列不包含值时，称其包含空值NULL。
> **NULL**  
> 无值（no value），与字段包含0、空字符串或者空格不同。

检查空值用IS NULL子句：  
```
SELECT cust_name
FROM Customers
WHERE cust_email IS NULL;
```  
## Chapter_5 高级数据过滤  
### 5.1 组合WHERE子句  
SQL允许给出多个WHERE子句，以AND子句或者OR子句的方式使用。
> **操作符（operator）**  
> 用来联结或改变WHERE子句中的子句的关键字，也称为逻辑操作符（logical operator）。

通过AND操作符给WHERE子句附加条件实现对不止一个列进行过滤。
```
SELECT prod_id, prod_price, prod_name
FROM Products
WHERE vend_id = 'DLL01' AND prod_price <= 4;
```
通过OR操作符给WHERE子句附加条件实现匹配任一条件的行。
```
SELECT prod_id, prod_price, prod_name
FROM Products
WHERE vend_id = 'DLL01' OR vend_id = 'BRS01';
```  
AND操作符优先级大于OR操作符，可以用圆括号对操作符进行明确分组。
```
SELECT prod_name, prod_price
FROM Products
WHERE (vend_id = 'DLL01' OR vend_id = 'BRS01') AND prod_price > 10;
```
### 5.2 IN操作符  
IN操作符用来指定条件范围，范围中的每个条件都可以进行匹配。
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
有且只有一个功能：否定其后所跟的任何条件。NOT从不单独使用，用在要过滤的列前，而不是在其后。
> **NOT**  
> WHERE子句中用来否定其后条件的关键字。

```
SELECT prod_name
FROM Products
WHERE NOT vend_id = 'DLL01'
ORDER BY prod_name;
```  
与IN操作符联合使用，NOT可以非常简单找出与条件列表不匹配的行。  
## Chapter_6 用通配符进行过滤  
### 6.1 LIKE操作符  










