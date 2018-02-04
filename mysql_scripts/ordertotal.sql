CREATE DEFINER=`zjumlw`@`localhost` PROCEDURE `ordertotal`(
	IN onumber INT,
    IN taxable BOOLEAN,
    OUT ototal DECIMAL(8,2)
)
    COMMENT 'Obtain order total, optoinally adding tax'
BEGIN
    -- Declare variable for total
    DECLARE total DECIMAL (8, 2);
    -- Declare tax percentage
    DECLARE taxrate INT DEFAULT 6;
    
    -- Get the order total
    SELECT Sum(item_price*quantity)
    FROM orderitems
    WHERE order_num = onumber
    INTO total;
    
    -- Is this taxable
    IF taxable THEN
		SELECT total + (total/100*taxrate) INTO total;
	END IF;
    -- Finally save to out variable
		SELECT total INTO ototal;
END