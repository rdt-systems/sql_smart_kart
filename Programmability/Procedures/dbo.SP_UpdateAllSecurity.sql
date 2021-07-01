SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_UpdateAllSecurity] as

update 	Users 
set 	DateModified=DateModified

update 	UsersStore 
set 	DateModified=DateModified

update 	Groups 
set 	DateModified=DateModified

update 	Registers 
set 	DateModified=DateModified

update 	[Authorization] 
set 	DateModified=DateModified

update 	Store 
set 	DateModified=DateModified

update 	SetUpValues 
set 	DateModified=DateModified
GO