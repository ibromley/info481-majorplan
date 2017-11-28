CREATE DEFINER=`ezhai24`@`%` PROCEDURE `uspAddTags`(IN TgName varchar(100), IN MjrName varchar(100))
BEGIN
	DECLARE MjrId INT;
    DECLARE TgId INT;
    SET MjrId = (SELECT MajorID FROM MAJOR WHERE MajorName = MjrName);
    SET TgId = (SELECT TagID FROM TAG WHERE TagName = TgName);

	START TRANSACTION;		
		INSERT INTO MAJOR_TAG(TagID, MajorID)
		VALUES(TgId, MjrId);
	COMMIT;
END