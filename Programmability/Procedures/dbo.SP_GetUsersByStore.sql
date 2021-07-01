SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetUsersByStore]
(@StoreID uniqueidentifier=null,
 @LogInStore uniqueidentifier)

as

 	SELECT   Distinct  UserId,UserName,UserFName,UserLName
	FROM       dbo.UsersView
	WHERE      (Status > - 1) AND  StoreID <> @LogInStore  And
			   (@StoreID is null Or StoreID = @StoreID) And  isnull(IsSuperAdmin,0)=0 
               And not Exists(Select * from UsersView as UV where UV.StoreID=@LogInStore And UsersView.UserId=UV.UserId)
GO