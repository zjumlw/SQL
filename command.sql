#DROP PROCEDURE IF EXISTS processorders;

#DROP TABLE ordertotals;
#call processorders();
#SELECT * from ordertotals;

#drop TRIGGER updatevendor;

#CREATE TRIGGER updatevendor BEFORE UPDATE ON vendors
#FOR EACH ROW SET NEW.vend_state = Upper(NEW.vend_state);
#SHOW COLLATION;
SELECT * FROM customers  as c1  
JOIN (SELECT round(rand()*(select max(cust_id) from customers))as id) as c2
where c1.cust_id>=c2.id
#WHERE cust_id >= (SELECT floor( RAND() * ((SELECT MAX(cust_id) FROM customers)-(SELECT MIN(cust_id) FROM customers)) + (SELECT MIN(cust_id) FROM customers)))    
ORDER BY c1.cust_id LIMIT 2; 