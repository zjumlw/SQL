#DROP PROCEDURE IF EXISTS processorders;

#DROP TABLE ordertotals;
#call processorders();
#SELECT * from ordertotals;

#drop TRIGGER updatevendor;

#CREATE TRIGGER updatevendor BEFORE UPDATE ON vendors
#FOR EACH ROW SET NEW.vend_state = Upper(NEW.vend_state);
