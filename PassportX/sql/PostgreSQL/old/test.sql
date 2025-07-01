	DROP TABLE IF EXISTS Person;

	CREATE TABLE Person (
		PersonID SERIAL UNIQUE,
		UserName varchar (30) NOT NULL ,
		Password varchar (50) NOT NULL ,
		FirstName varchar (50) NULL ,
		Surname varchar (50) NULL ,
		EMail varchar (50) NULL ,
		TelNo varchar (35) NULL ,
		CellPhone varchar (20) NULL ,
		Token varchar (36) NULL ,
		TokenExpiryDate timestamp NULL ,
		PersonStatusID integer NULL ,
		LoginFailures integer NULL ,
		PasswordExpiryDate timestamp NOT NULL ,
		LastLoginDate timestamp NULL ,
		LoginFailureDate timestamp NULL ,
		AccLockedDate timestamp NULL 
	);
	
	ALTER TABLE Person ADD CONSTRAINT PK_Person PRIMARY KEY
		(
			PersonID
		);

	CREATE INDEX idx_Token ON Person (Token);

	insert into Person (username, password, firstname, surname, email, telno, cellphone, personstatusid, loginfailures, passwordexpirydate) select 'sa', 'password', 'System', 'Administrator', 'passportX@umlungu.com', '', '', 1, 0, '31 Dec 2100';

/*
	CREATE TABLE Person (
		PersonID SERIAL UNIQUE PRIMARY KEY,
		UserName varchar (30) NOT NULL ,
		Password varchar (50) NOT NULL ,
		FirstName varchar (50) NULL ,
		Surname varchar (50) NULL ,
		EMail varchar (50) NULL ,
		TelNo varchar (35) NULL ,
		CellPhone varchar (20) NULL ,
		Token uniqueidentifier NULL ,
		TokenExpiryDate smalldatetime NULL ,
		PersonStatusID tinyint NULL ,
		LoginFailures tinyint NULL ,
		PasswordExpiryDate datetime NOT NULL ,
		LastLoginDate datetime NULL ,
		LoginFailureDate datetime NULL ,
		AccLockedDate datetime NULL 
	);
*/

