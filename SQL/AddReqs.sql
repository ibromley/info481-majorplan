USE `majorplan`;
DROP procedure IF EXISTS `uspAddReqs`;

DELIMITER $$
USE `majorplan` $$
CREATE PROCEDURE `uspAddReqs`(IN ReqName varchar(100), IN MajorName varchar(100))
BEGIN
	DECLARE MajorId INT;
    DECLARE ReqId INT;
    SET MajorID = (SELECT MajorID FROM MAJOR WHERE MajorName = @MajorName);

	START TRANSACTION;
		INSERT INTO REQ(ReqName)
		VALUES(@ReqName);
		
		SET ReqId = SCOPE_IDENTITY();
		
		INSERT INTO MAJOR_REQ(ReqID, MajorID)
		VALUES(ReqId, MajorId);
	COMMIT;
END
$$
