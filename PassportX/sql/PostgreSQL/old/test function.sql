	--DROP VIEW IF EXISTS x_User;
	--DROP FUNCTION IF EXISTS x_UserGet;
	
	CREATE OR REPLACE VIEW x_User AS
			SELECT PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
				 Token, Person.PersonStatusID AS "PersonStatusID", PersonStatus.Description AS "PersonStatusDesc", AccLockedDate
			FROM Person
			INNER JOIN PersonStatus ON Person.PersonStatusID = PersonStatus.PersonStatusID;

	CREATE OR REPLACE VIEW x_UserLogin AS
			SELECT	PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					LoginFailures, PasswordExpiryDate, AccLockedDate, 
					Person.PersonStatusID AS "PersonStatusID", PersonStatus.Description AS "PersonStatusDesc"
			FROM Person
			INNER JOIN PersonStatus ON Person.PersonStatusID = PersonStatus.PersonStatusID;
/*	-----------------------------------------------------------------------
	Procedure: x_UserGet
		- Stored procedure to retrieve a specific user's details
	Parameters:
		UserID:			User identifier
		UserName:		Username
		UserToken:		User's login token (guid)
		UserCellPhone:	User's cellphone number
	Returns:
		x_User:			View
	----------------------------------------------------------------------- */
	CREATE OR REPLACE FUNCTION x_UserGet (
		UserID int,
		UserName varchar(50),
		UserToken varchar(50),
		UserCellPhone varchar(20)
	) RETURNS x_User AS $$
			SELECT * FROM x_User
			WHERE ($1 != 0 AND PersonID = $1)
				OR ($2 != '' AND UserName = $2)
				OR ($3 != '' AND Token = $3)
				OR ($4 != '' AND CellPhone = $4);
	$$ LANGUAGE SQL;
	
	
/*	-----------------------------------------------------------------------
	Procedure: x_UserLoginGet
		- Stored procedure to retrieve a specific user's details
	Parameters:
		UserName:		Username
	Returns:
		x_UserLogin:	View
	----------------------------------------------------------------------- */
	CREATE OR REPLACE FUNCTION x_UserLoginGet (
		UserName varchar(50)
	) RETURNS x_UserLogin AS $$
			SELECT * FROM x_UserLogin
			WHERE UserName = $1;
	$$ LANGUAGE SQL;

	
/*	-----------------------------------------------------------------------
	Procedure: x_UserSetLoginFailure
		- Stored procedure to set login failure
	Parameters:
		UserName:		Username
	Returns:
		x_UserLogin:	View
	----------------------------------------------------------------------- */
	CREATE OR REPLACE FUNCTION x_UserSetLoginFailure (
		UserID int,
		FailCount int,
		FailDate timestamp with time zone,
		LockDate timestamp with time zone
	) RETURNS void AS $$
		UPDATE Person
			SET LoginFailures = $2,
				LoginFailureDate = $3,
				AccLockedDate = $4
		WHERE PersonID = $1
	$$ LANGUAGE SQL;

	
/*	-----------------------------------------------------------------------
	Procedure: x_UserSetLoginOK
		- Stored procedure to set login ok
	Parameters:
		UserName:		Username
	Returns:
		x_UserLogin:	View
	----------------------------------------------------------------------- */
	CREATE OR REPLACE FUNCTION x_UserSetLoginOK (
		UserID int,
		FailCount int,
		Token varchar(50),
		LoginDate timestamp with time zone,
		TokenDate timestamp with time zone,
		ExpireDate timestamp with time zone
	) RETURNS void AS $$
		UPDATE Person
			SET LoginFailures = $2,
				Token = $3,
				TokenExpiryDate = $5,
				PasswordExpiryDate = $6,
				LastLoginDate = $4
		WHERE PersonID = $1
	$$ LANGUAGE SQL;
		