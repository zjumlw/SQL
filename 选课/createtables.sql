# CREATE department TABLE
CREATE TABLE dept(
	DeptNum 		char(10) 	NOT NULL,
	DeptName 		varchar(20) NOT NULL,
	DeptChairman    varchar(10) NOT NULL,
	DeptTel 		varchar(15) NOT NULL,
	DeptDesc 		text 		NOT NULL,
	PRIMARY KEY (DeptNum)
);

# CREATE major TABLE
CREATE TABLE major(
	MajorNum		char(10) 	NOT NULL,
	DeptNum			char(10) 	NOT NULL,
	MajorName		varchar(20) NOT NULL,
	MajorAssistant	varchar(10) NOT NULL,
	MajorTel		varchar(15)	NOT NULL,
	PRIMARY KEY (MajorNum)
);

# CREATE student TABLE
CREATE TABLE student(
	StudentNum 		char(10)	NOT NULL,
	MajorNum		char(10)	NOT NULL,
	StudentName		varchar(10)	NOT NULL,
	StudentSex		char(2)		NOT NULL,
	StudentBirthday	date		NOT NULL,
	StudentPassword	varchar(20) NOT NULL,
	PRIMARY KEY (StudentNum)
);

# CREATE teacher TABLE
CREATE TABLE teacher(
	TeacherNum		char(10)	NOT NULL,
	DeptNum			char(10)	NOT NULL,
	TeacherName		varchar(10)	NOT NULL,
	TeacherSex		char(2)		NOT NULL,
	TeacherBirthday	date		NOT NULL,
	TeacherTitle	varchar(20)	NULL,
	PRIMARY KEY (TeacherNum)
);

# CREATE manager TABLE
CREATE TABLE manager(  
	ManagerNum 		char(10) 	NOT NULL,
	ManagerName 	varchar(10) NOT NULL,  
	ManagerSex 		char(2) 	NOT NULL,  
	ManagerBirthdate datetime 	NOT NULL,  
	ManagerRights 	int 		NOT NULL,
	PRIMARY KEY (ManagerNum)
 );

# CREATE course TABLE
CREATE TABLE course(
	CourseNum 		varchar(10)	NOT NULL,
	CourseName		varchar(20)	NOT NULL,
	CourseCredit	float		NOT NULL,
	CourseClass		smallint	NOT NULL,
	CourseDesc 		text		NOT NULL,
	PRIMARY KEY	(CourseNum)
);

# CREATE stucourse TABLE
 CREATE TABLE stucourse(
	stucourseNum	char(10)	NOT NULL,
	StudentNum 		char(10)	NOT NULL,
	CourseNum		char(10)	NOT NULL,
	TeacherNum		char(10)	NOT NULL,
	Grade 			smallint	NULL,
	PRIMARY KEY (stucourseNum)
);
 
# CREATE control TABLE
 CREATE TABLE control(
	controlNum		char(10)	NOT NULL,
	IfTakeCourse	char(1)	NOT NULL check(IfTakeCourse in ('0', '1')),
	IfInputGrade	char(1)	NOT NULL check(IfInputGrade in ('0', '1')),
	PRIMARY KEy (controlNum)
 );
 
# Define foreign keys
ALTER TABLE major 		ADD CONSTRAINT fk_major_dept 		FOREIGN KEY (DeptNum) 		REFERENCES dept (DeptNum);
ALTER TABLE student 	ADD CONSTRAINT fk_student_major 	FOREIGN KEY (MajorNum) 		REFERENCES major (MajorNum);
ALTER TABLE teacher 	ADD CONSTRAINT fk_teacher_dept 		FOREIGN KEY (DeptNum) 		REFERENCES dept (DeptNum);
ALTER TABLE stucourse	ADD CONSTRAINT fk_stucourse_student FOREIGN KEY (StudentNum) 	REFERENCES student (StudentNum);
ALTER TABLE stucourse 	ADD CONSTRAINT fk_stucourse_course 	FOREIGN KEY (CourseNum) 	REFERENCES course (CourseNum);
ALTER TABLE stucourse 	ADD CONSTRAINT fk_stucourse_teacher FOREIGN KEY (TeacherNum) 	REFERENCES teacher (TeacherNum);

#创建必要视图


