CREATE DEFINER=`ezhai24`@`%` PROCEDURE `uspAddMajors`(IN MjrName varchar(100))
BEGIN
    START TRANSACTION;
		INSERT INTO MAJOR(MajorName)
		VALUES(MjrName);
	COMMIT;
END