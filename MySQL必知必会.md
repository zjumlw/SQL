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

## Chapter 24 使用游标
### 24.1 游标
MySQL检索操作返回一组称为结果集的行。  
在检索出来的行中前进或后退一行或多行，这就是游标的作用。  
游标（cursor）是一个存储在MySQL服务器上的数据库查询，不是一条SELECT语句，而是被该语句检索出来的结果集。

> **只能用于存储过程**

### 24.2 使用游标
步骤：
- 在能够使用游标前，必须声明它，定义要使用的SELECT语句；
- 
- 一旦声明后，必须打开游标以供使用，用前面定义的SELECT语句把数据实际检索出来；
- 对于填有数据的游标，根据需要取出检索各行；
- 在结束游标使用时，必须关闭游标。

在声明游标后，可根据需要频繁地打开和关闭游标。  
在游标打开后，可根据需要频繁地执行取操作。

#### 24.2.1 创建游标
DECLARE命名游标，并定义相应的SELECT语句，根据需要带WHERE和其他子句：
```
CREATE PROCEDURE processorders()
BEGIN
	DECLARE ordernumbers CURSOR
	FOR 
	SELECT order_num FROM orders;
END; 
```

定义命名了游标ordernumbers。  
存储过程处理完成后，游标就消失。

#### 24.2.2 打开和关闭游标
OPEN CURSOR语句打开：
```
OPEN ordernumbers;
```

在处理OPEN语句时执行查询，存储检索出的数据以供浏览和滚动。  
游标处理之后，关闭游标：
```
CLOSE ordernumbers;
```

CLOSE释放游标使用的所有内部内存和资源，因此在每个游标不再需要时都要关闭。  
使用过声明过的游标不需要再次声明，用OPEN语句打开就可以了。

> **隐含关闭**
> 如果不明确关闭游标，MySQL将会在到达END语句时自动关闭它。

```
CREATE PROCEDURE processorders()
BEGIN
	DECLARE ordernumbers CURSOR
	FOR
	SELECT order_num FROM orders;
	OPEN ordernumbers;
	CLOSE ordernumbers;
END;
```

#### 24.2.3 使用游标数据
使用FETCH语句分别访问每一行，指定检索什么数据，检索出来的数据存储在什么地方：
```
CREATE PROCEDURE processorders()
BEGIN
	DECLARE o INT;
	DECLARE ordernumbers CURSOR
	FOR
	SELECT order_num FROM orders;
	OPEN ordernumbers;
	FETCH ordernumbers INTO o;
	CLOSE ordernumbers;
END;
```

FETCH检索当前行的order_num列（自动从第一行开始）到一个名为o的局部声明的变量中，对检索出的数据不做处理。

结合之前的内容，对取出的数据进行某种处理：
```
CREATE DEFINER=`zjumlw`@`localhost` PROCEDURE `processorders`()
BEGIN
	-- Declare local variables
    declare t decimal(8,2);
    DECLARE o INT;
    DECLARE done BOOLEAN DEFAULT 0;
    
    -- Declare the cursor
	DECLARE ordernumbers CURSOR
	FOR
	SELECT order_num FROM orders;
    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
    
    -- Create a table to store the results
    CREATE TABLE IF NOT EXISTS ordertotals
		(order_num INT, total DECIMAL(8,2));
        
    -- Open the cursor
	OPEN ordernumbers;
    -- Loop through all rows
    REPEAT
    
    -- Get order number
	FETCH ordernumbers INTO o;
    
    -- Get the total for this order
    CALL ordertotal(o,1,t);
    
    -- Insert order and total into ordertotals
    INSERT INTO ordertotals(order_num,total)
    VALUES(o,t);
    
    -- End of loop
    UNTIL done END REPEAT;
    
    -- Close the cursor
	CLOSE ordernumbers;
END
```

变量t存储每个订单的合计。创建新表ordertotals来保存存储过程生成的结果。FETCH取得每一个order_num，然后用CALL执行另一个存储过程来计算每个订单的带税的合计，最后用INSERT语句保存每个订单的订单号和合计。

查看该表：
```
call processorders();
SELECT * from ordertotals
GROUP BY total;
```

## Chapter 25 使用触发器
### 25.1 触发器
在某个表发生更改时自动处理，需要触发器。例如：
- DELETE；
- INSERT；
- UPDATE。

### 25.2 创建触发器
需要给出4条信息：
- 唯一的触发器名；
- 触发器关联的表；
- 触发器应该相应的活动（DELETE、INSERT或UPDATE）；
- 触发器何时执行（处理之前或之后）。

使用CREATE TRIGGER语句创建触发器：
```
CREATE  TRIGGER newproduct AFTER INSERT ON product
FOR EACH ROW SELECT 'Product added';
```

创建名为newproduct的触发器，在INSERT语句成功执行后执行，FOR EACH ROW表示对每个插入行执行，文本Product added将对每个插入的行显示一次。

> **仅支持表**
> 不支持视图和临时表。

每个表最多支持6个触发器（每条INSERT、UPDATE和DELETE的之前和之后）。单一触发器不能与多个事件或多个表关联，如果需要对INSERT和UPDATE操作执行的触发器，应该定义两个触发器。

### 25.3 删除触发器
使用DROP TRIGGER删除触发器：
```
DROP TRIGGER newproduct;;
```

> 触发器不能更新或覆盖，修改一个触发器必须先删除它，然后再重新创建。

### 25.4 使用触发器
#### 25.4.1 INSERT触发器
在INSERT语句之前或之后执行：
- 在INSERT触发器内部，可引用一个名为NEW的虚拟表，访问被插入的行；
- 在BEFORE INSERT触发器中，NEW中的值也可以被更新；
- 对于AUTO_INCREMENT列，NEW在INSERT执行之前包含0，在INSERT执行之后包含新的自动生成值。

新生成值的方法：
```
CREATE TRIGGER neworder AFTER INSERT ON orders
FOR EACH ROW SELECT NEW.order_num INTO @tmp;
```

测试该触发器：
```
INSERT INTO orders(order_date, cust_id)
VALUES(now(),10001);
SELECT @tmp_num;
```
> 此处原书本的代码会出错：not allowed to return a result set from a trigger，具体问题不详。按照上面更改后可以显示新插入行的order_num。



#### 25.4.2 DELETE触发器
需要知道：
- 在DELETE触发器代码内，可以引用一个名为OLD的虚拟表，访问被删除的行；
- OLD中的值全都是只读的，不能更新。

```
delimiter //
CREATE TRIGGER deleteorder BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
	INSERT INTO archive_orders(order_num, order_date, cust_id)
    VALUES(OLD.order_num, OLD.order_date, OLD.cust_id);
    END; //
delimiter ;   
```

> **多语句触发器**
> 这里使用BEGIN END语句标记触发器体，可以容纳多条SQL语句。


#### 25.4.1 UPDATE触发器
需要知道：
- 在UPDATE触发器代码中，可以引用一个名为OLD的虚拟表访问以前的值，引用一个名为NEW的虚拟表访问新更新的值；
- 在BEFORE UPDATE触发器中，NEW中的值可能也被更新；
- OLD中的值全都是只读的，不能更新。

保证州名缩写总是大写：
```
CREATE TRIGGER updatevendor BEFORE UPDATE ON vendors
FOR EACH ROW SET NEW.vend_state = Upper(NEW.vend_state);
```

## Chapter 26 管理事务处理
### 26.1 事务处理
事务处理（transaction processing）用来维护数据库的完整性，保证成批的MySQL操作要么完全执行，要么完全不执行。  
关键词：
- 事务（transaction）：一组SQL语句；
- 回退（rollback）：撤销指定SQL语句的过程；
- 提交（commit）：将未存储的SQL语句结果写入数据库表；
- 保留点（savepoint）：事务处理中设置的临时占位符，可以对它发布回退。

### 26.2 控制事务处理
标识事务开始：
```
START TRANSACTION
```

#### 26.2.1 使用ROLLBACK
```
SELECT * FROM ordertotals;
START TRANSACTION
DELETE FROM ordertotals;
SELECT * FROM ordertotals;
ROLLBACK;
SELECT * FROM ordertotals;
```

ROLLBACK只能在一个事务处理内使用。

> 事务处理用来管理INSERT、UPDATE和DELETE语句，不能回退SELECT语句，不能回退CREATE或DROP操作。

#### 26.2.2 使用COMMIT
一般的MySQL语句都是直接针对数据库表执行和编写的，这是隐含提交，是自动进行的。  
在事务处理块中，进行明确的提交，使用COMMIT语句：
```
START TRANSACTION
DELETE FROM orderitems WHERE order_num = 20010;
DELETE FROM order WHERE order_num = 20010;
COMMIT;
```

> **隐含事务关闭**
> 当COMMIT或ROLLBACK语句执行后，事务会自动关闭；

#### 26.2.3 使用保留点
复杂的事务处理可能需要部分提交或回退。  
使用保留点SAVEPOINT：
```
SAVEPOINT delete1;
```

> 每个保留点取标识它的唯一名字。

回退到保留点：
```
ROLLBACK TO delete1;
```

> **保留点越多越好**
> 越多越灵活。

> **释放保留点**
> 保留点在事务处理完成（执行一条ROLLBACK或COMMIT）后自动释放。也可以使用RELEASE SAVEPOINT来明确释放保留点。

####  26.2.4 更改默认的提交行为
```
SET autocommit = 0;
```

指示MySQL不自动提交更改。

## Chapter 27 全球化和本地化
### 27.1 字符集和校对顺序
数据库表被用来存储和检索数据，不同的语言和字符集需要以不同方式存储和检索。  
针对多种语言和字符集，会有：
- **字符集**为字母和符号的集合；
- **编码**为某个字符集成员的内部表示；
- **校对**为规定字符如何比较的指令。

使用何种字符集和校对的决定在服务器、数据库和表级进行。

### 27.2 使用字符集和校对顺序
查看所支持的字符集完整列表：
```
SHOW CHARACTER SET;
```

查看所支持校对的完整列表：
```
SHOW COLLATION;
```

有的字符集具有不止一种校对，区分大小写（_cs），不区分大小写（—_ci）。

确定所用的字符集和校对，使用以下语句：
```
SHOW VARIABLES LIKE 'character%';
SHOW VARIABLES LIKE 'collation%';
```

实际上字符集很少是服务器范围，不同的表，甚至不同的列都可能需要不同的字符集，可以在创建表时确定。

## Chapter 28 安全管理
### 28.1 访问控制
MySQL服务器的安全基础：用户应该对他们需要的数据具有适当的访问权，既不能多也不能少。

> **不要使用root**
> 仅在绝对需要时使用它，不应该在日常的MySQL操作中使用root。

### 28.2 管理用户
MySQL用户帐号和信息存储在名为mysql的数据库中。需要直接访问它的时机之一是在需要获得所有用户帐号列表时：
```
USE mysql;
SELECT user FROM user;
```

### 28.2.1 创建用户帐号
创建一个新用户帐号：
```
CREATE USER ben IDENTIFIED BY 'P@$$word';
```

创建用户帐号时不一定口令。  
重命名一个用户账户，使用RENAME USER语句：
```
RENAME USER ben To ftorta;
```

#### 28.2.2 删除用户帐号
使用DROP USER语句：
```
DROP USER bforta;
```

删除用户帐号和所有相关的帐号权限。

#### 28.2.3 设置访问权限
新创建的用户帐号没有访问权限，可以登录MySQL但不能看到数据，不能执行任何数据库操作。  
显示用户帐号的权限：
```
SHOW GRANTS FOR bforta;
```

为设置权限，使用GRANT语句，至少给出一下信息：
- 要授予的权限；
- 被授予访问权限的数据库或表；
- 用户名。

```
GRANT SELECT ON crashcourse.* TO bforta;
```

允许用户使用SELECT语句，只有读访问权限。

GRANT的反操作为REVOKE，用来撤销特定的权限：
```
REVOKE SELECT ON crashcourse.* FROM bforta;
```

> 被撤销的访问权限必须在，否则会出错。

GRANT和REVOKE可在几个层次上控制访问权限：
- 整个服务器，使用GRANT ALL和REVOKE ALL；
- 整个数据库，使用ON databases.*;
- 特定的表，使用ON databases.table;
- 特定的列；
- 特定的存储过程。

> **未来的授权**
> 在使用GRANT和REVOKE是，用户帐号必须存在，但是对所涉及的对象没有这个要求。允许管理员在创建数据库和表之前设计和实现安全措施。当某个数据库或表被删除时，相关的访问权限仍然存在，如果将来重新创建该数据库或表，这些权限仍然其作用。  
> 
> **简化多次授权**
> 可以列出个权限并用逗号分隔，将多条GRANT语句串在一起：
> ```
> GRANT SELECT, INSERT ON crashcourse.* TO bforta;
> ```


#### 28.2.4 更改口令 
使用SET PASSWORD语句：
```
SET PASSWORD FOR bforta = PASSWORD('afsd');
```

不指定用户名时，SET PASSWORD更新当前登录用户的口令。

## Chapter 29 数据库维护
### 29.1 备份数据
可能解决方案：
- 使用命令行mysqldump转储所有数据库内容到某个外部文件；
- 用命令行mysqlhotcopy从一个数据库复制所有数据；
- 使用MySQL的BACKUP TABLE或SELECT INTO OUTFILE转储所有数据到某个外部文件。

### 29.2 进行数据库维护
一下维护的语句：
- ANALYZE TABLE，用来检测表键是否正确；

```
ANALYZE TABLE orders;
```

- CHECK TABLE用来针对许多问题对表进行检查；
- 如果MyISAM表访问产生不正确和不一致的结果，可能需要用REPAIR TABLE来修复相应的表（该语句不能经常使用）；
- 如果从一个表中删除大量数据，应该使用OPTIMIZE TABLE来收回所用的空间，从而优化性能。

### 29.3 诊断启动问题
首先尽量用手动启动服务器，MySQL服务器自身通过在命令行上执行mysqld启动：
- --help显示帮助--一个选项列表；
- --safe-mode装载减去某些最佳配置的服务器；
- --verbose显示全文本消息；
- --version显示版本信息然后退出。

### 29.4 查看日志文件
日志文件有以下几种：
- 错误日志；
- 查询日至；
- 二进制日志；
- 缓冲查询日志。

## Chapter 30 改善性能
### 30.1 改善性能
性能不良的数据库是常见的祸因，以下是进行性能优化探讨和分析的一个出发点：
- 应该坚持遵循硬件建议；
- 关键的生产DBMS应该运行在自己的专用服务器上；
- 默认设置很好，过一段时间可能需要调整内存分配、缓冲区大小等；
- MySQL是多用户多线程的DBMS，经常同时执行多个任务，如果某一个任务执行缓慢，则所有请求都会执行缓慢。可使用SHOW PROCESSLIST显示所有活动进程，可用KILL命令终结某个特定的进程；
- 总是有不止一种方法编写同一句SELECT语句，应该试验联结、并、子查询等，找出最佳方法；
- 使用EXPLAIN语句让MySQL解释它如何执行一条SELECT语句；
- 一般来说，存储过程执行比一条一条执行语句快；
- 应该总是使用正确的数据类型；
- 决不要检索比需求还要多的数据；
- 有的操作支持一个可选的DELAYED关键字，如果使用它，将把控制立即返回给调用程序，并且一旦有可能就实际执行该操作；
- 在导入数据时，应该关闭自动提交。删除索引然后在导入完成后再重建他们；
- 必须索引数据库表以改善数据检索的性能；
- 通过使用多条SELECT语句和连接他们的UNION语句，可以极大地改善性能；
- 索引改善数据检索的性能，但损害数据插入、删除和更新的性能；
- LIKE很慢，最好使用FULLTEXT而不是LIKE；
- 数据库是不断变化的实体；
- 每一条规则在某些条件下都会被打破。
- 