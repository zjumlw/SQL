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