 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClient')
	Begin
		IF col_length('tblClient', 'WelcomeCallLetterNeeded') is null
				Alter table tblClient Add WelcomeCallLetterNeeded bit Null 
	End    