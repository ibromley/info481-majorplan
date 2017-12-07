CREATE DEFINER=`ezhai24`@`%` PROCEDURE `uspAddCourses`(IN CrsName varchar(100), IN MinGrd FLOAT, IN MjrName varchar(100))
BEGIN
	DECLARE MjrId INT;
    DECLARE CrsId INT;
	SET MjrId = (SELECT MajorID FROM MAJOR WHERE MajorName = MjrName);

    START TRANSACTION;
		INSERT INTO COURSE(CourseName)
		VALUES(CrsName);
		
		SET CrsId = LAST_INSERT_ID();
		
		INSERT INTO MAJOR_COURSE(CourseID, MajorID, MinGrade)
		VALUES(CrsId, MjrId, MinGrd);
	COMMIT;
END