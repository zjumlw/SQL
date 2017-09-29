## MySQL随机获取一条或多条数据

### 研究随机获取一条或多条数据：

**方法一：**

```mysql
SELECT * FROM tablename ORDER BY RAND() LIMIT 5;
```

但是rand()放在ORDER BY子句中会被执行多次，效率很低。

**方法二：**

使用max(id)*rand()来随机获取数据。

```mysql
SELECT *
FROM tablename AS t1 
JOIN (SELECT ROUND(RAND()*(SELECT MAX(id) FROM tablename)) AS id) AS t2
WHERE t1.id>=t2.id
ORDER BY t1.id ASC LIMIT 5;
```

会产生连续的5条记录，解决方法是每次查询一条，查询5次。

问题是数据不是随机的，而是连续的。

**方法三：**

如果不使用join语句：

```mysql
SELECT *
FROM tablename
WHERE id >= (SELECT floor(MAX(id)*RAND()) FROM tablename)
ORDER BY id LIMIT 1;
```

随机获取一个数据，速度相对方法二稍微慢一点。经过修改：

```mysql
SELECT *
FROM tablename
WHERE id >= (SELECT floor(RAND()*(SELECT MAX(id) FROM tablename)))
ORDER BY id LIMIT 1;
```

速度相对快了一点。

加上MIN(id)的判断：

```mysql
SELECT * FROM `table`   
WHERE id >= (SELECT floor( RAND() * ((SELECT MAX(id) FROM `table`)-(SELECT MIN(id) FROM `table`)) + (SELECT MIN(id) FROM `table`)))    
ORDER BY id LIMIT 5;  

SELECT *   
FROM `table` AS t1 JOIN (SELECT ROUND(RAND() * ((SELECT MAX(id) FROM `table`)-(SELECT MIN(id) FROM `table`))+(SELECT MIN(id) FROM `table`)) AS id) AS t2   
WHERE t1.id >= t2.id   
ORDER BY t1.id LIMIT 5;  
```

上述代码中，前者花费时间比后者多，后者效率更高。



**sql语句有几种写法**

1：SELECT * FROM tablename ORDER BY RAND() LIMIT 想要获取的数据条数；

2：SELECT *FROM `table` WHERE id >= (SELECT FLOOR( MAX(id) * RAND()) FROM `table` ) ORDER BY id LIMIT 想要获取的数据条数;

3：SELECT * FROM `table`  AS t1 JOIN (SELECT ROUND(RAND() * (SELECT MAX(id) FROM `table`)) AS id) AS t2 WHERE t1.id >= t2.id
ORDER BY t1.id ASC LIMIT 想要获取的数据条数;

4：SELECT * FROM `table`WHERE id >= (SELECT floor(RAND() * (SELECT MAX(id) FROM `table`))) ORDER BY id LIMIT 想要获取的数据条数;

5：SELECT * FROM `table` WHERE id >= (SELECT floor( RAND() * ((SELECT MAX(id) FROM `table`)-(SELECT MIN(id) FROM `table`)) + (SELECT MIN(id) FROM `table`))) ORDER BY id LIMIT 想要获取的数据条数;

6：SELECT * FROM `table` AS t1 JOIN (SELECT ROUND(RAND() * ((SELECT MAX(id) FROM `table`)-(SELECT MIN(id) FROM `table`))+(SELECT MIN(id) FROM `table`)) AS id) AS t2 WHERE t1.id >= t2.id ORDER BY t1.id LIMIT 想要获取的数据条数;

1的查询时间>>2的查询时间>>5的查询时间>6的查询时间>4的查询时间>3的查询时间，也就是3的效率最高。

但是3是连续的，6比较好。