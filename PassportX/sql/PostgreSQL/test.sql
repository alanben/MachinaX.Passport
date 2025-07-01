	CREATE OR REPLACE FUNCTION x_test2(
		UserName varchar(50),	--$1
		Password varchar(50),	--$2
		FirstName varchar(50),	--$3
		Surname varchar(50),	--$4
		Email varchar(50),		--$5
		TelNo varchar(35),		--$6
		CellNo varchar(20)		--$7
	) RETURNS integer AS $$
		DECLARE
			UserID int;
			PasswExpiryDte int;
			PasswordExpiryDte timestamp with time zone;
		BEGIN
			UserID := 0;
			SELECT RetValue FROM Config WHERE Description = 'PasswordExpiryDate' INTO PasswExpiryDte;
			PasswordExpiryDte := now() + CAST ((PasswExpiryDte || 'day') AS interval); -- + PasswExpiryDte
			IF NOT EXISTS (SELECT UserName FROM Person WHERE UserName = $1) THEN
				IF NOT EXISTS (SELECT CellPhone FROM Person WHERE CellPhone = $7) THEN
					INSERT INTO Person VALUES (DEFAULT, $1, $2, $3, $4, $5, $6, $7, null, null, 1, 0, PasswordExpiryDte, null, null, null);
					SELECT PersonID FROM person WHERE username = $1 INTO UserID;
				ELSE
					UserID := 0;
				END IF;
			END IF;
			RETURN UserID;
		END;
	$$ LANGUAGE 'plpgsql' VOLATILE;
