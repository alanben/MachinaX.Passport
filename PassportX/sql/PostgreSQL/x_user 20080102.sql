/*	-----------------------------------------------------------------------	
	Copyright:	umlungu consulting (pty) ltd
	Author:		Alan Benington
	Started:	2007-05-27	
	Status:		redev	
	Version:	2.0.0
	Build:		20070820
	License:	GNU General Public License
	-----------------------------------------------------------------------	*/
	
/*	-------------------------------------------------------------------------------------------------
	PassportX:
	==========
	Refactored database for PassportX.
	Refactoring objectives are:
		1.	Convert all structures and procedures to EngineX naming conventions.
		2.	Refine structure and code to requirements of the PassportX classes.
		3.	Create templates for equivalent proceduires in other db's (eg MySQL)
	-------------------------------------------------------------------------------------------------	*/
	
/*	----------------------------------------------------------------------------------------------------------------------------------------------	
	Development Notes:
	==================
	20070602:	Starting point from Gatekeeper
	20070820:	Ammended x_UserLogin to update Token when account locked
				Ammended x_UserLockClear to take alternative Token parameter
	20071228:	Starting point for PostgreSQL version from MsSQL version
	----------------------------------------------------------------------------------------------------------------------------------------------	*/
	
/*	-----------------------------------------------------------------------
	CREATE OR REPLACE VIEW(s)
	-----------------------------------------------------------------------	*/
		
	CREATE OR REPLACE VIEW x_User AS
			SELECT PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
				 Token, Person.PersonStatusID AS "PersonStatusID", PersonStatus.Description AS "PersonStatusDesc", AccLockedDate
			FROM Person
			INNER JOIN PersonStatus ON Person.PersonStatusID = PersonStatus.PersonStatusID;

/*	-----------------------------------------------------------------------
	CREATE OR REPLACE FUNCTION(s)
	-----------------------------------------------------------------------	*/
		
	CREATE OR REPLACE FUNCTION x_UserGet (
		@UserID int,
		@UserName varchar(50),
		@UserToken varchar(50),
		@UserCellPhone varchar(20)
	)  RETURNS x_User AS $$
	/*	-----------------------------------------------------------------------
		Procedure: x_UserGet
			- Stored procedure to retrieve a specific user's details
		Parameters:
			@UserID:		User identifier
			@UserName:		Username
			@UserToken:		User's login token (guid)
			@UserCellPhone:	User's cellphone number
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			SELECT * FROM x_User
			WHERE ($1 != 0 AND PersonID = $1)
				OR ($2 != '' AND UserName = $2)
				OR ($3 != '' AND Token = $3)
				OR ($4 != '' AND CellPhone = $4);
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserLogin (
		@UserName varchar(30),
		@Password varchar(50),
		@Userid int OUTPUT
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Validate a user's login information
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Declare @PersonID int, @Token UniqueIdentifier
			Declare @PWord varchar(50), @LFailures int
			Declare @TExpiryDate datetime, @TokenDate int
			Declare @PExpiryDate datetime, @FailureTimes int
			Declare @AccLockedTime int, @AccLockedDate datetime
			Declare @PersonAccLockedDate datetime, @Result varchar(50), @PersonStatus Varchar(50)
			Declare @ExpiryDate int, @PasswordExpiryDate datetime
			
			Select @Result = ''
			Select @PersonID = PersonID, @PWord = Password, @LFailures = LoginFailures, @PExpiryDate = PasswordExpiryDate, @PersonAccLockedDate = AccLockedDate, @PersonStatus = PersonStatus.Description
				From Person
					Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					Where UserName = @UserName
			Select @Userid = @PersonID
			If DATEDIFF(hh, @PersonAccLockedDate, getdate()) < 0
				Begin
					Select @Token = NewID()
					Update Person
						Set Token = @Token
						Where PersonID = @PersonID        
					Select @Result = 'Account still locked'
				End
			Else If @PersonStatus <> 'Active'
				Begin
					Select @Result = 'Account is ' + @PersonStatus
				End
			Else
				Begin
					If DATEDIFF(hh, @PersonAccLockedDate, getdate()) = 0 Or DATEDIFF(hh, @PersonAccLockedDate, getdate()) IS NULL
						Begin
							Update Person
								Set AccLockedDate = null, LoginFailures = 0
								Where PersonID = @PersonID
						End
					If @Password = @PWord
						Begin
							If CONVERT(varchar(11), @PExpiryDate, 103) = CONVERT(varchar(11), getdate(), 103)
								Begin
									Select @Result = 'Password has expired'
								End
							Else
								Begin
									Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
									Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
									Select @Token = NewID()
									Select @ExpiryDate = RetValue From Config Where Description = 'PasswordExpiryDate'
									Select @PasswordExpiryDate = DATEADD(dd, @ExpiryDate, getdate())

									Update Person
										Set Token = @Token,
											TokenExpiryDate = @TExpiryDate,
											PasswordExpiryDate = @PasswordExpiryDate,
											LoginFailures = 0,
											LastLoginDate = getdate()
										Where PersonID = @PersonID        
								End  
						End 
					Else
						Begin
							Select @FailureTimes = RetValue From Config Where Description = 'LoginFailures'
							Select @AccLockedTime = RetValue From Config Where Description = 'AccLockedDate'
							If @LFailures = @FailureTimes
								Begin
									Select @Result = 'Loginfailure limit reached'
								End
							Else
								Begin
									Select @LFailures = @LFailures + 1
									Select @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())
									If @LFailures = @FailureTimes
										Begin
											Update Person
												Set LoginFailures = @LFailures,
													LoginFailureDate = getdate(),
													AccLockedDate = @AccLockedDate
											Where PersonID = @PersonID
											Select @Result = 'Incorrect Password'
										End
									Else
										Begin
											Update Person
											Set LoginFailures = @LFailures,
												LoginFailureDate = getdate()
												Where PersonID = @PersonID
											Select @Result = 'Incorrect Password'
										End
								End 
						End
				End
			Select Token = @Token, Result = @Result
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserLogout (
		@Token uniqueidentifier
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			- Stored procedure for...
		Parameters:
			@parameter1:	the GUID supplied by the Gatekeeper when the user logged in
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Update Person
				Set Token = null, TokenExpiryDate = null
				Where Token = @Token
	$$ LANGUAGE SQL;

	
	CREATE OR REPLACE FUNCTION x_UserPasswordExpire (
		@UserID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			- Method used to force the expiry of a user's password, which will force them to renew their password at next logon.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Update Person
			Set PasswordExpiryDate = getdate()
			Where PersonID = @UserID
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserQuestionValidate (
		@UserID int,
		@QuestionID int,
		@Answer varchar(100),
		@Result varchar(50) OUTPUT
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Validates a user's answer to a question against a value in the Gatekeeper database. 
			If the answer matches the answer stored in the database for the User and Question, 
			the method will return OK;
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Declare @CorrectAns varchar(100)
			
			Select @CorrectAns = Answer
				From Answer 
				Where PersonID = @UserID
					And QuestionID = @QuestionID
			
			If @CorrectAns = @Answer
				Begin
					Select @Result = 'OK'
				End
			Else
				Begin
					Select @Result = 'Incorrect Answer'
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserStatusDelete (
		@PersonStatusID int,
		@Result varchar(25) Output
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to remove a PersonStatus record from the Gatekeeper database. 
			The system will first check whether the record is still in use before attempting to delete the record.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If Exists (Select PersonStatusID From Person Where PersonStatusID = @PersonStatusID)
				Begin
					Select @Result = 'Cannot delete'
				End
			Else
				Begin
					Delete PersonStatus Where PersonStatusID = @PersonStatusID
					Select @Result = ''
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserDelete (
		@UserID int,
		@UserName varchar(50)
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Remove a user from the Gatekeeper database. All records associated with the user will also be removed
			ie. all service and product links, group links and activity logged.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If @UserID = 0 Or @UserID IS NULL
				Begin
					Select @UserID = PersonID From Person Where UserName = @UserName
				End
			-- Delete the PersonService record!
			Delete PersonService Where PersonID = @UserID
			-- Delete the PersonGroup record!
			Delete PersonGroup Where PersonID = @UserID
			-- Delete the PersonProduct record!
			Delete PersonProduct Where PersonID = @UserID
			-- Delete the ActivityLog record!
			Delete ActivityLog Where PersonID = @UserID
			-- Delete the Answer record!
			Delete Answer Where PersonID = @UserID
			-- Delete the Person record!
			Delete Person Where PersonID = @UserID
			Exec x_NotificationAdd @UserID, 104
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserGroupDelete (
		@UserID int,
		@GroupID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to remove a user from a Group in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Delete PersonGroup Where PersonID = @UserID And GroupID = @GroupID
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserProductDelete (
		@UserID int,
		@UserName varchar(50),
		@ProductID int,
		@ProductName varchar(100)
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to remove the link between a user and a Product.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If @UserID = 0
				Begin
					Select @UserID = PersonID From Person Where UserName = @UserName
				End
				
			If @ProductID = 0
				Begin
					Select @ProductID = ProductID From Product Where Description = @ProductName
				End

			Delete PersonProduct Where PersonID = @UserID And ProductID = @ProductID
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserServiceDelete (
		@UserID int,
		@UserName varchar(50),
		@ServiceID int,
		@ServiceName varchar(100)
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Remove the link between a user and specific service.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Declare @NewUserID int
			Declare @NewServiceID int
			
			If @UserID = 0  
				Begin
					Select @NewUserID = PersonID From Person Where UserName = @UserName
				End
			Else
				Begin
					Select @NewUserID = @UserID
				End

			If @ServiceID = 0
				Begin
					Select @NewServiceID = ServiceID From Service Where Description = @ServiceName
				End
			Else
				Begin
					Select @NewServiceID = @ServiceID
				End

			Delete PersonService Where PersonID = @NewUserID And ServiceID = @NewServiceID
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserServiceList (
		@PersonID int, 
		@ServiceID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			The name of a service to return the access to, and also relevant permissions and status information.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If @ServiceID = 0 --Return all Services where PersonID linked to
				Begin
					Select Service.ServiceID,
						ServiceIdentifier, 
						Service.Description, 
						ServiceStatus.Description As Status, 
						ServiceStatus.DisplayMessage, 
						SecurityLevel.Description As SecurityLevel
						From PersonService 
							Inner Join Service On PersonService.ServiceID = Service.ServiceID
							Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
							Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
							Where PersonID = @PersonID
				End
			Else --Return only specific Service information
				Begin
					Select Service.ServiceID,
						ServiceIdentifier, 
						Service.Description, 
						ServiceStatus.Description As Status, 
						ServiceStatus.DisplayMessage, 
						SecurityLevel.Description As SecurityLevel
						From PersonService 
							Inner Join Service On PersonService.ServiceID = Service.ServiceID
							Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
							Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
							Where PersonService.PersonID = @PersonID
								And PersonService.ServiceID = @ServiceID
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserStatusGet (
		@PersonStatusID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Return details for a specific Person Status in the Gatekeeper database.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
	As RETURNS xxx AS $$
		Begin
			Select Description, PersonStatusID
				From PersonStatus
					Where PersonStatusID = @PersonStatusID
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserStatusGetList(
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Returns a list of all person status' in the Gatekeeper database
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Select PersonStatusID, Description From PersonStatus
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserAdd (
		@UserName varchar(50),
		@Password varchar(50),
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@UserID int OUTPUT
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to register a user on the Gatekeeper system. This method will only be called once for a user, when
			they register to use the system. The system will assign a User ID to the user, which will be returned,
			but which the user should not know - it is for internal referencing only. All updates associated with
			the user will be done using the User ID. This method will most likely be called by a user interface
			where the user has the option to register to make use of the online services which the Gatekeeper controls
			access to.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
		Declare @PasswExpiryDate int, @PasswordExpiryDate datetime
		Select @PasswExpiryDate = RetValue From Config Where Description = 'PasswordExpiryDate'
		Select @PasswordExpiryDate = DATEADD(dd, @PasswExpiryDate, getdate())
		
		If Not Exists (Select UserName From Person Where UserName = @UserName)
			Begin 
				If Not Exists (Select CellPhone From Person Where CellPhone = @CellNo)
					Begin 
						Insert Into Person (UserName, Password, FirstName, Surname, Email, TelNo, CellPhone, PasswordExpiryDate, LoginFailures, PersonStatusID)
							Select @UserName, @Password, @FirstName, @Surname, @Email, @TelNo, @CellNo, @PasswordExpiryDate, 0, 1
							Select @UserID = @@IDENTITY
							Exec x_NotificationAdd @UserID, 100
					End
				Else
					Begin
						Select @UserID = 0
					End     
			End
		Else
			Begin
				Select @UserID = 0      
			End  
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserStatusAdd (
		@PersonStatusID int OUTPUT,
		@Description varchar(50)
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Add/update a PersonStatus record in the Gatekeeper database. 
			All PersonStatus records must have unique descriptions.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If @PersonStatusID > 0 --Update!
				Begin
					Update PersonStatus
						Set Description = @Description
						Where PersonStatusID = @PersonStatusID
				End
			Else  --Insert!
				Begin
					Insert Into PersonStatus (Description) Select @Description
					Select @PersonStatusID = @@IDENTITY
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserAnswerAdd (
		@UserID int,
		@QuestionID int,
		@Answer varchar(100)
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Add/update an answer for a user to a question, for password reminders.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If Exists (Select PersonID, QuestionID From Answer Where PersonID = @UserID And QuestionID = @QuestionID)
				Begin
					Update Answer
						Set Answer = @Answer
						Where PersonID = @UserID And QuestionID = @QuestionID
				End
			Else
				Begin
					Insert Into Answer (QuestionID, PersonID, Answer)
					Select @QuestionID, @UserID, @Answer
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserGroupAdd (
		@UserID int,
		@GroupID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Add a User to a Group in the Gatekeeper database. 
			Checks that the user is not already a member of the Group before adding the record. 
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If Not Exists (Select PersonID, GroupID From PersonGroup Where PersonID = @UserID And GroupID = @GroupID)
				Begin
					Insert Into PersonGroup (PersonID, GroupID) Select @UserID, @GroupID
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserProductAdd (
		@UserID int,
		@UserName varchar(50),
		@ProductID int,
		@ProductName varchar(100),
		@SecurityLevelID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Method used to link a user to a Product, and assign a security level to the user. If a user is already
			linked to a Product, the system will update the SecurityLevel associated with that product only.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Declare @ServiceStatusID int

			If @UserID = 0  
				Begin
					Select @UserID = PersonID From Person Where UserName = @UserName
				End
			If @ProductID = 0
				Begin
					Select @ProductID = ProductID From Product Where Description = @ProductName
				End
			If Exists (Select PersonID, ProductID From PersonProduct Where PersonID = @UserID And ProductID = @ProductID)
				Begin
					Update PersonProduct
						Set SecurityLevelID = @SecurityLevelID
						Where PersonID = @UserID And ProductID = @ProductID
				End
			Else
				Begin
					Insert Into PersonProduct (PersonID, ProductID, SecurityLevelID)
						Select @UserID, @ProductID, @SecurityLevelID
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserServiceAdd (
		@UserID int,
		@UserName varchar(50),
		@ServiceID int,
		@ServiceName varchar(100),
		@SecurityLevelID int,
		@ServiceIdentifier varchar(50)
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Link a user to a selected service.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Declare @ServiceStatusID int
			If @UserID = 0  
				Begin
					Select @UserID = PersonID From Person Where UserName = @UserName
				End
			If @ServiceID = 0
				Begin
					Select @ServiceID = ServiceID From Service Where Description = @ServiceName
				End
			If Not Exists (Select * From PersonService Where PersonID = @UserID And ServiceID = @ServiceID And SecurityLevelID = @SecurityLevelID)
				Begin
					Insert Into PersonService (PersonID, ServiceID, SecurityLevelID, ServiceIdentifier)
						Select @UserID, @ServiceID, @SecurityLevelID, @ServiceIdentifier
				End
			Update PersonService
				Set ServiceIdentifier = @ServiceIdentifier
				Where PersonID = @UserID And ServiceID = @ServiceID
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserUpdate (
		@UserID int,
		@UserName varchar(50),
		@Password varchar(50),
		@FirstName varchar(50),
		@Surname varchar(50),
		@Email varchar(50),
		@TelNo varchar(35),
		@CellNo varchar(20),
		@PersonStatusID int,
		@Result Varchar(50) OUTPUT
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			- Stored procedure for...
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If Exists(Select * From Person Where PersonID = @UserID)
				Begin
					If Exists(Select * From Person Where Username = @UserName AND PersonID <> @UserID)
						Begin
							Select @Result = 'Invalid Username supplied - Username already exists.'
						End
					Else
						Begin
							if @Password = ''
								Begin
									Update Person
									Set UserName = @UserName,
										FirstName = @FirstName,
										Surname = @Surname,
										Email = @Email,
										TelNo = @TelNo,
										CellPhone = @CellNo,
										PersonStatusID = @PersonStatusID
									Where PersonID = @UserID
								End
							Else
								Begin
									Update Person
									Set UserName = @UserName,
										Password = @Password,
										FirstName = @FirstName,
										Surname = @Surname,
										Email = @Email,
										TelNo = @TelNo,
										CellPhone = @CellNo,
										PersonStatusID = @PersonStatusID
									Where PersonID = @UserID
								End
							Exec x_NotificationAdd @UserID, 101
						End
				End
			Else
				Begin
					Select @Result = 'Invalid User ID supplied - User does not exist.'
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserStatusUpdate (
		@PersonID int,
		@UserName Varchar(50),
		@Status varchar(50)
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Unlock a user from accessing transactional systems managed by the Gatekeeper, using the User/Login Name.
			Can do the same by locking - set a user's status!
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If @PersonID = 0 Or @PersonID IS NULL
				Begin
					Select @PersonID = PersonID From Person
						Where UserName = @UserName
				End
			If @PersonID = 0 Or @PersonID IS NULL
				Begin
					Return
				End
			Declare @PrevStatus Varchar(50)
			Select @PrevStatus = Description
				From PersonStatus
					Inner Join Person On Person.PersonStatusID = PersonStatus.PersonStatusID
					Where PersonID = @PersonID
			Update Person
				Set PersonStatusID = PersonStatus.PersonStatusID
				From PersonStatus
					Where PersonID = @PersonID And Description = @Status
			If @Status = 'Deleted'
				Begin
					Exec x_NotificationAdd @PersonID, 102
				End
			If @Status = 'Active' And @PrevStatus = 'Deleted' -- Undelete User
				Begin
					Exec x_NotificationAdd @PersonID, 103
				End
			If @Status = 'Locked'
				Begin
					Exec x_NotificationAdd @PersonID, 105
				End
			If @Status = 'Active' And @PrevStatus = 'Locked' -- Unlock User
				Begin
					Exec x_NotificationAdd @PersonID, 106
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserValidate (
		@Token uniqueidentifier,
		@Service varchar(100),
		@Userid int OUTPUT,
		@Result Varchar(100) OUTPUT
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			relevant permissions and status information.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Declare @PersonID int
			Declare @ServiceID int
			Declare @TokenDate Int, @TExpiryDate DateTime
			Select @PersonID = PersonID, @TExpiryDate = TokenExpiryDate From Person Where Token = @Token
			Select @Userid = @PersonID
			Select @ServiceID = ServiceID From Service Where Description = @Service

			If @TExpiryDate IS NULL Or DateDiff(n, Getdate(), @TExpiryDate) < 0
				Begin
					Select @Result = 'User session has expired, or user has not yet logged in.'
					Return
				End
				
			Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
			Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
			Update Person
				Set TokenExpiryDate = @TExpiryDate, LastLoginDate = getdate()
				Where PersonID = @PersonID
				
			If @Service = '' --Return all Services where PersonID linked to
				Begin
					Select PersonService.PersonID,
						Service.ServiceID,
						ServiceIdentifier, 
						Service.Description, 
						ServiceStatus.Description As Status, 
						ServiceStatus.DisplayMessage, 
						SecurityLevel.Description As SecurityLevel
						From PersonService 
							Inner Join Service On PersonService.ServiceID = Service.ServiceID
							Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
							Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
							Where PersonID = @PersonID
				End
			Else --Return only specific Service information
				Begin
					Select PersonService.PersonID,
						Service.ServiceID,
						ServiceIdentifier, 
						Service.Description, 
						ServiceStatus.Description As Status, 
						ServiceStatus.DisplayMessage, 
						SecurityLevel.Description As SecurityLevel
						From PersonService 
							Inner Join Service On PersonService.ServiceID = Service.ServiceID
							Inner Join ServiceStatus On Service.ServiceStatusID = ServiceStatus.ServiceStatusID
							Inner Join SecurityLevel On PersonService.SecurityLevelID = SecurityLevel.SecurityLevelID
							Where PersonService.PersonID = @PersonID And PersonService.ServiceID = @ServiceID
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserLockClear (
		@UserID int,
		@Token varchar(65)
) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Restore a user who was previously delete to active status.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Declare @ThisToken uniqueidentifier
			Set @ThisToken = CAST(@Token AS uniqueidentifier )

			If Exists(Select * From Person Where PersonID = @UserID or (Token = @ThisToken and @Token <> ''))
				Begin
					Update Person
						Set LoginFailureDate = NULL,
							AccLockedDate = NULL,
							LoginFailures = 0
						Where PersonID = @UserID or (Token = @ThisToken and @Token <> '')
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserProfileDelete (
		@UserID int,
		@GroupID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to remove a Profile from a User in the Gatekeeper database (remove user from Group). 
			Will also remove the rights (ServiceID/SecurityLevelID) associated with the Profile
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Begin
				Delete PersonGroup
				Where PersonID = @UserID
				And GroupID = @GroupID
			End
			Begin
				Delete PersonService
					Where PersonID = @UserID 
					AND ServiceID IN
						(SELECT ServiceID
							FROM ProfileService
								WHERE GroupID = @GroupID
								AND ProfileService.SecurityLevelID = PersonService.SecurityLevelID
						)
					AND ServiceID NOT IN
						(SELECT	PersonService.ServiceID
							FROM PersonService 
							INNER JOIN ProfileService
							ON PersonService.ServiceID = ProfileService.ServiceID
							AND ProfileService.SecurityLevelID = PersonService.SecurityLevelID
								WHERE PersonService.PersonID = @UserID
								AND ProfileService.GroupID IN
									(SELECT GroupID
										FROM PersonGroup
											WHERE PersonID = @UserID
											AND GroupID <> @GroupID
									)
						)
			End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserList (
		@GroupID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: x_UserList
			Retrieves users within a group (or all).
		Parameters:
			@GroupID:		Group identifier
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If @GroupID > 0 
				Select	Person.PersonID, 
						UserName, 
						Password, 
						FirstName, 
						Surname, 
						Email, 
						TelNo, 
						CellPhone,
						Token, 
						Person.PersonStatusID, 
						PersonStatusDesc = PersonStatus.Description,
						PersonGroup.GroupID
				From Person
					Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					Inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
					Where PersonGroup.GroupID = @GroupID
						and Person.PersonID > 5
			Else
				Select	PersonID, 
						UserName, 
						Password, 
						FirstName, 
						Surname, 
						Email, 
						TelNo, 
						CellPhone,
						Token, 
						Person.PersonStatusID, 
						PersonStatusDesc = PersonStatus.Description
				From Person
					Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
						and Person.PersonID > 5
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserGetName (
		@UserID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Retrieves a specific user's username.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Select UserName From Person Where PersonID = @UserID
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserListPaged (
		@GroupID int,
		@StartRow int,
		@NumberRows int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: x_UserListPaged
			- Retrieves users within a group (or all).
		Parameters:
			@GroupID:		Group identifier
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Declare	@TotalRows int
			CREATE TABLE #UserTemp (
				[RowID] [int] IDENTITY (1, 1) NOT NULL ,
				[PersonID] [int],
				[UserName] [varchar] (30)  ,
				[FirstName] [varchar] (50)  ,
				[Surname] [varchar] (50)  ,
				[EMail] [varchar] (50)  ,
				[TelNo] [varchar] (35)  ,
				[CellPhone] [varchar] (20)  ,
				[Status] [varchar] (50)  ,
				[GroupID] [int],
				[GroupName] [varchar] (100)  ,
				CONSTRAINT [PK_UserTemp] PRIMARY KEY  CLUSTERED ( [RowID] )
			)
			
			If @GroupID > 0 
				Insert into #UserTemp (
					[PersonID] , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					[Status] ,
					GroupID ,
					GroupName)
				select 
					Person.PersonID , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					Status = PersonStatus.Description ,
					@GroupID ,
					GroupName = Groups.Description
				from Person 
					inner join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
					inner Join Groups On PersonGroup.GroupID = Groups.GroupID
					where PersonGroup.GroupID = @GroupID
						and Person.PersonID > 5
					order by Person.PersonID
			Else
				Insert into #UserTemp (
					[PersonID] , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					[Status] ,
					GroupID )
				select 
					Person.PersonID , 
					[UserName] ,
					[FirstName] ,
					[Surname] ,
					[EMail] ,
					[TelNo] ,
					[CellPhone] ,
					Status = PersonStatus.Description,
					@GroupID
				from Person 
					inner join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					where Person.PersonID > 5
				order by Person.PersonID
			
			Set @TotalRows = @@ROWCOUNT
			
			Select * from #UserTemp 
				where RowID between @StartRow and @StartRow + @NumberRows - 1
				order by RowID
			
			Drop table #UserTemp
			
			Select TotalRows = @TotalRows
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserListPagedSorted (
		@GroupID int,
		@ColumnName varchar(30),
		@StartRow int,
		@NumberRows int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: x_UserListPagedSorted
			- Retrieves users within a group (or all).
		Parameters:
			@GroupID:		Group identifier
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
		
			Declare	@TotalRows int
			Declare @SQLSelect Varchar(1000)
			Declare @SQLOrder Varchar(200)
			Declare @SQLWhere Varchar(200)
			
			CREATE TABLE #UserTemp (
				[RowID] [int] IDENTITY (1, 1) NOT NULL ,
				[PersonID] [int],
				[UserName] [varchar] (30)  ,
				[FirstName] [varchar] (50)  ,
				[Surname] [varchar] (50)  ,
				[EMail] [varchar] (50)  ,
				[TelNo] [varchar] (35)  ,
				[CellPhone] [varchar] (20)  ,
				[Status] [varchar] (50)  ,
				[GroupID] [int],
				[GroupName] [varchar] (100)  ,
				CONSTRAINT [PK_UserTemp] PRIMARY KEY  CLUSTERED ( [RowID] )
			)
			Set @SQLSelect = 'Insert into #UserTemp ([PersonID], [UserName], [FirstName], [Surname], [EMail], [TelNo], [CellPhone], [Status]'
			if @GroupID > 0
				Set @SQLSelect = @SQLSelect + ', GroupID, GroupName ) '
			else
				Set @SQLSelect = @SQLSelect + ') '
			
			Set @SQLSelect = @SQLSelect + 'select Person.PersonID ,[UserName] ,[FirstName] ,[Surname] ,[EMail] ,[TelNo] ,[CellPhone], Status = PersonStatus.Description '
			if @GroupID > 0
				Set @SQLSelect = @SQLSelect + ', PersonGroup.GroupID, GroupName = Groups.Description '
			
			Set @SQLSelect = @SQLSelect + 'from Person inner join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID '
			if @GroupID > 0
				begin
					Set @SQLSelect = @SQLSelect + 'inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID '
					Set @SQLSelect = @SQLSelect + 'inner Join Groups On PersonGroup.GroupID = Groups.GroupID '
				end
			
			if @GroupID > 0
				begin
					Set @SQLWhere = 'where PersonGroup.GroupID = ' + Convert(Varchar(5), @GroupID)
					Set @SQLWhere = @SQLWhere + 'and Person.PersonID > 5'
				end
			else
				Set @SQLWhere = 'where Person.PersonID > 5'
			
			Set @SQLOrder = ' order by '
			Set @SQLOrder = @SQLOrder + @ColumnName
			
			EXEC (@SQLSelect + @SQLWhere + @SQLOrder)  
			
			Set @TotalRows = @@ROWCOUNT
			
			Select * from #UserTemp 
				where RowID between @StartRow and @StartRow + @NumberRows - 1
				order by RowID
			
			Drop table #UserTemp
			Select TotalRows = @TotalRows
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserProfileList (
		@UserID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Retrieves the groups (profiles) for a user.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Select PersonGroup.PersonID, 
				PersonGroup.GroupID, 
				Groups.GroupStatusID, 
				GroupDesc = Groups.Description, 
				GroupStatus = GroupStatus.Description
				From PersonGroup
					Inner Join Groups On PersonGroup.GroupID = Groups.GroupID
					Inner Join GroupStatus On Groups.GroupStatusID = GroupStatus.GroupStatusID
				Where PersonID = @UserID
				Order by GroupDesc
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserProfileAdd (
		@UserID int,
		@GroupID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Used to add a User to a Group in the Gatekeeper database. 
			The system will check that the user is not already a member of the Group before adding the record. 
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			CREATE TABLE #ServiceTemp ([PersonID] [int], [ServiceID] [int], [SecurityLevelID] [int])
				Insert into #ServiceTemp ([PersonID], [ServiceID], [SecurityLevelID])
				Select 	PersonService.PersonID,
						PersonService.ServiceID, 
						PersonService.SecurityLevelID from PersonService
						Join ProfileService
							on ProfileService.ServiceID = PersonService.ServiceID and ProfileService.SecurityLevelID = PersonService.SecurityLevelID
						Where PersonService.PersonID = @UserID and ProfileService.GroupID = @GroupID
		End
		Begin
			If Not Exists (Select PersonID, GroupID From PersonGroup Where PersonID = @UserID And GroupID = @GroupID)
				Begin
					Insert Into PersonGroup (PersonID, GroupID)
					Select @UserID, @GroupID
				End
			Insert Into PersonService (PersonID, ServiceID, SecurityLevelID)
			Select @UserID, ProfileService.ServiceID, ProfileService.SecurityLevelID
				From ProfileService 
				Where ProfileService.GroupID = @GroupID
					And ServiceID NOT IN (Select ServiceID from #ServiceTemp)
			Drop table #ServiceTemp
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserSearch (
		@GroupID int,
		@SearchName varchar(20),
		@SearchNo varchar(20),
		@Exact int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Retrieves users within a group (or all).
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
		If @GroupID > 0 
				Select Person.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
				     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description,
				     PersonGroup.GroupID
				From Person
				Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
				Inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
				Where PersonGroup.GroupID = @GroupID
						and (UserName Like @SearchName + '%'
							Or FirstName Like @SearchName + '%'
							Or Surname Like @SearchName + '%'
							Or TelNo Like @SearchNo + '%'
							Or CellPhone Like @SearchNo + '%')
		Else
				Begin
					If @Exact > 0
						Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
						     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description
						From Person
						Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
						Where UserName = @SearchName Or CellPhone = @SearchNo
					Else
						Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
						     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description
						From Person
						Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
						Where UserName Like @SearchName + '%'
							Or FirstName Like @SearchName + '%'
							Or Surname Like @SearchName + '%'
							Or TelNo Like @SearchNo + '%'
							Or CellPhone Like @SearchNo + '%'
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserSearchAdvanced (
		@GroupID int,
		@SearchUserID varchar(20),
		@SearchUserName varchar(20),
		@SearchFirstName varchar(20),
		@SearchSurname varchar(20),
		@SearchEmail varchar(20),
		@SearchTelNo varchar(20),
		@SearchCellNo varchar(20)
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Retrieves users within a group (or all).
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
				If @GroupID > 0 
					Select Person.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description,
					     PersonGroup.GroupID
					From Person
					Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					Inner Join PersonGroup On Person.PersonID = PersonGroup.PersonID
					Where PersonGroup.GroupID = @GroupID
							and (Person.PersonID Like @SearchUserID + '%'
								Or UserName Like @SearchUserName + '%'
								Or FirstName Like @SearchFirstName + '%'
								Or Surname Like @SearchSurname + '%'
								Or TelNo Like @SearchTelNo + '%'
								Or CellPhone Like @SearchCellNo + '%'
								Or Email Like @SearchEmail + '%')
				Else
					Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					     Token, Person.PersonStatusID, PersonStatusDesc = PersonStatus.Description
					From Person
					Inner Join PersonStatus On Person.PersonStatusID = PersonStatus.PersonStatusID
					Where PersonID Like @SearchUserID + '%'
						Or UserName Like @SearchUserName + '%'
						Or FirstName Like @SearchFirstName + '%'
						Or Surname Like @SearchSurname + '%'
						Or TelNo Like @SearchTelNo + '%'
						Or CellPhone Like @SearchCellNo + '%'
						Or Email Like @SearchEmail + '%'
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserLockSet (
		@UserID int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			- Stored procedure for...
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Declare @LFailures int, @FailureTimes int, @AccLockedTime int, @AccLockedDate datetime

			Select @FailureTimes = RetValue From Config Where Description = 'LoginFailures'
			Select @AccLockedTime = RetValue From Config Where Description = 'AccLockedDate'
			Select @LFailures = @FailureTimes + 1
			Select @AccLockedDate = DATEADD(hh, @AccLockedTime, getdate())

			Update Person
				Set LoginFailures = @LFailures,
					LoginFailureDate = getdate(),
					AccLockedDate = @AccLockedDate
				Where PersonID = @UserID
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserPasswordUpdate (--1, '', 'Test Password' 
		@UserID int,
		@UserName varchar(50),
		@Password varchar(50)
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Update a user's password.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Declare @NewUserID int
			Declare @ExpiryDate int
			Declare @PasswordExpiryDate datetime
			If @UserID = 0 
				Begin
					Select @NewUserID = PersonID From Person Where UserName = @UserName
				End
			Else
				Begin
					Select @NewUserID = @UserID
				End
				
			Select @ExpiryDate = RetValue From Config Where Description = 'PasswordExpiryDate'
			Select @PasswordExpiryDate = DATEADD(dd, @ExpiryDate, getdate())
				
			If Exists (Select PersonID From Person Where PersonID = @NewUserID)
				Begin
					Update Person
						Set Password = @Password, PasswordExpiryDate = @PasswordExpiryDate
						Where PersonID = @NewUserID
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_Validate (
		@Token uniqueidentifier
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			Validates the token.
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Declare @PersonID int
			Declare @ServiceID int
			Declare @TokenDate Int, @TExpiryDate DateTime
			Declare @Result Varchar(100)
			Select @PersonID = PersonID, @TExpiryDate = TokenExpiryDate From Person Where Token = @Token
			If @TExpiryDate IS NULL Or DateDiff(n, Getdate(), @TExpiryDate) < 0
				Select @Result = 'User session has expired, or user has not yet logged in.'
			Else
				Begin
					Select @Result = 'ok'
					Select @TokenDate = RetValue From Config Where Description = 'SessionExpiryTime'
					Select @TExpiryDate = DATEADD(mi, @TokenDate, getdate())
					
					Update Person
					Set TokenExpiryDate = @TExpiryDate,
						LastLoginDate = getdate()
					Where PersonID = @PersonID
				End
			Select Result = @Result
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserFind (
		@GroupID int,
		@SearchName varchar(20),
		@SearchNo varchar(20),
		@Exact int
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: x_UserFind
			- Stored procedure for retrieving users within a group (or all).
		Parameters:
			@GroupID:		Group identifier
			@SearchName:	Name or partial name to search on
			@SearchNo:		Name or partial number to search on
			@Exact:			Flag for exact search, exact=1
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If @GroupID > 0 
				Select P.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					 Token, P.PersonStatusID, PersonStatusDesc = PS.Description,
					 PG.GroupID
				From Person as P
				Inner Join PersonStatus as PS On P.PersonStatusID = PS.PersonStatusID
				Inner Join PersonGroup as PG On P.PersonID = PG.PersonID
				Where PG.GroupID = @GroupID
						and (UserName Like @SearchName + '%'
							Or FirstName Like @SearchName + '%'
							Or Surname Like @SearchName + '%'
							Or TelNo Like @SearchNo + '%'
							Or CellPhone Like @SearchNo + '%')
			Else
				Begin
					If @Exact > 0
						Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
							 Token, StatusID = P.PersonStatusID, Status = PS.Description
						From Person as P
						Inner Join PersonStatus as PS On P.PersonStatusID = PS.PersonStatusID
						Where UserName = @SearchName Or CellPhone = @SearchNo
					Else
						Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
							 Token, StatusID = P.PersonStatusID, Status = PS.Description
						From Person as P
						Inner Join PersonStatus as PS On P.PersonStatusID = PS.PersonStatusID
						Where UserName Like @SearchName + '%'
							Or FirstName Like @SearchName + '%'
							Or Surname Like @SearchName + '%'
							Or TelNo Like @SearchNo + '%'
							Or CellPhone Like @SearchNo + '%'
				End
	$$ LANGUAGE SQL;


	CREATE OR REPLACE FUNCTION x_UserFindAdvanced (
		@GroupID int,
		@SearchUserID varchar(20),
		@SearchUserName varchar(20),
		@SearchFirstName varchar(20),
		@SearchSurname varchar(20),
		@SearchEmail varchar(20),
		@SearchTelNo varchar(20),
		@SearchCellNo varchar(20)
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: x_UserFindAdvanced
			- Stored procedure for retrieving users within a group (or all).
			- Uses non-exact matches on a number of parameters
		Parameters:
			@GroupID:			Group identifier
			@SearchUserID:		User's identifier
			@SearchUserName:	User's username
			@SearchFirstName:	User's first name
			@SearchSurname:		User's surname
			@SearchEmail:		User's email address
			@SearchTelNo:		User's contact (not cell) number
			@SearchCellNo:		User's cell number
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			If @GroupID > 0 
				Select P.PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					 Token, StatusID = P.PersonStatusID, Status = PS.Description, PG.GroupID
				From Person as P
				Inner Join PersonStatus as PS On P.PersonStatusID = PS.PersonStatusID
				Inner Join PersonGroup as PG On P.PersonID = PG.PersonID
				Where PG.GroupID = @GroupID
						and (P.PersonID Like @SearchUserID + '%'
							Or UserName Like @SearchUserName + '%'
							Or FirstName Like @SearchFirstName + '%'
							Or Surname Like @SearchSurname + '%'
							Or TelNo Like @SearchTelNo + '%'
							Or CellPhone Like @SearchCellNo + '%'
							Or Email Like @SearchEmail + '%')
			Else
				Select PersonID, UserName, Password, FirstName, Surname, Email, TelNo, CellPhone,
					 Token, StatusID = P.PersonStatusID, Status = PS.Description
				From Person as P
				Inner Join PersonStatus as PS On P.PersonStatusID = PS.PersonStatusID
				Where PersonID Like @SearchUserID + '%'
					Or UserName Like @SearchUserName + '%'
					Or FirstName Like @SearchFirstName + '%'
					Or Surname Like @SearchSurname + '%'
					Or TelNo Like @SearchTelNo + '%'
					Or CellPhone Like @SearchCellNo + '%'
					Or Email Like @SearchEmail + '%'
	$$ LANGUAGE SQL;

	
	CREATE OR REPLACE FUNCTION x_UserPassword (
		@UserID int,
		@UserName varchar(50)
	) RETURNS xxx AS $$
	/*	-----------------------------------------------------------------------
		Procedure: Template
			- Stored procedure for...
		Parameters:
			@parameter1:	Description of @parameter1...
			@parameter2:	Description of @parameter2...
		Returns:
			0:	Success
			n:	Some error condition
		-----------------------------------------------------------------------	*/
			Select UserName, FirstName, PersonName = FirstName + ' ' + Surname, CellPhone, EMail, Password
				From Person
				Where PersonID = @UserID Or UserName = @UserName
	$$ LANGUAGE SQL;

