USE `majorplan`;
DROP procedure IF EXISTS `uspAddTags`;

DELIMITER $$
USE `majorplan`$$
CREATE PROCEDURE `uspAddTags` ()
BEGIN
	DECLARE MajorId INT;
    DECLARE TagId INT;
    SET MajorID = (SELECT MajorID FROM MAJOR WHERE MajorName = @MajorName);

	START TRANSACTION;
		INSERT INTO TAG(TagName)
		VALUES(@TagName);
		
		SET TagId = SCOPE_IDENTITY();
		
		INSERT INTO MAJOR_TAG(TagID, MajorID)
		VALUES(TagId, MajorId);
	COMMIT;
END$$

DELIMITER ;
