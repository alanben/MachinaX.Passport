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
	Procedure: x_UserSetLoginFail
		- Stored procedure to set login failure
	Parameters:
		UserName:		Username
	Returns:
		x_UserLogin:	View
	----------------------------------------------------------------------- */
	CREATE OR REPLACE FUNCTION x_UserSetLoginFail (
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
		
		
	/*	-----------------------------------------------------------------------
		Procedure: x_UserAdd
			Used to register a user on the PassportX system. This method will only be called once for a user, when
			they register to use the system. The system will assign a User ID to the user, which will be returned,
			but which the user should not know - it is for internal referencing only. All updates associated with
			the user will be done using the User ID. This method will most likely be called by a user interface
			where the user has the option to register to make use of the online services which the PassportX controls
			access to.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	CREATE OR REPLACE FUNCTION x_UserAdd (
		UserName varchar(50),
		Password varchar(50),
		FirstName varchar(50),
		Surname varchar(50),
		Email varchar(50),
		TelNo varchar(35),
		CellNo varchar(20)
	) RETURNS person AS $$
		Insert Into Person (UserName, Password, FirstName, Surname, Email, TelNo, CellPhone, PasswordExpiryDate, LoginFailures, PersonStatusID)
			Select $1, $2, $3, $4, $5, $6, $7, now() + interval '90 day', 0, 1;
		Select * from Person
			where UserName = $1;
	$$ LANGUAGE SQL;

	
	CREATE OR REPLACE FUNCTION x_test() RETURNS void AS $func$
	DECLARE
	    referrer_key RECORD;  -- declare a generic record to be used in a FOR
	    func_body text;
	    func_cmd text;
	BEGIN 
	    func_body := 'BEGIN';

	    -- Notice how we scan through the results of a query in a FOR loop
	    -- using the FOR <record> construct.

	    FOR referrer_key IN SELECT * FROM cs_referrer_keys ORDER BY try_order LOOP
	        func_body := func_body ||
	          ' IF v_' || referrer_key.kind
	          || ' LIKE ' || quote_literal(referrer_key.key_string)
	          || ' THEN RETURN ' || quote_literal(referrer_key.referrer_type)
	          || '; END IF;' ;
	    END LOOP; 

	    func_body := func_body || ' RETURN NULL; END;';

	    func_cmd :=
	      'CREATE OR REPLACE FUNCTION cs_find_referrer_type(v_host varchar,
	                                                        v_domain varchar,
	                                                        v_url varchar) 
	        RETURNS varchar AS '
	      || quote_literal(func_body)
	      || ' LANGUAGE plpgsql;' ;

	    EXECUTE func_cmd;
	END;
	$func$ LANGUAGE plpgsql;

