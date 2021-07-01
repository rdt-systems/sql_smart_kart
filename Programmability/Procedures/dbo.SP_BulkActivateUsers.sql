SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE Procedure [dbo].[SP_BulkActivateUsers](
	@StartSQ nvarchar(20),
	@EndSQ nvarchar(20),
	@GroupID Uniqueidentifier,
	@Store Uniqueidentifier)

AS
PRINT 'Start'
Declare @StartNo decimal(25,0),  @EndNo decimal(25,0), @No nvarchar(20), @Current decimal(25,0), @UserID Uniqueidentifier, @UserStoreID Uniqueidentifier, @Name nvarchar(50), @Pass nvarchar(50)

Set @No = '192321330'

Select @StartNo = CONVERT(decimal(25,0), @No + @StartSQ)
SELECT @EndNo = CONVERT(decimal(25,0), @No + @EndSQ)
PRINT 'Start With'
;WITH Nbrs AS (
    SELECT CONVERT(decimal(25,0),ISNULL(@StartNo,0)) AS Value UNION ALL
    SELECT CONVERT(decimal(25,0),ISNULL(Value,0) + 1) FROM Nbrs 
	Where Nbrs.Value < @EndNo
) SELECT * Into #MyList From Nbrs

PRINT 'Start Loop'
Declare B Cursor For Select * From #MyList

Open B

FETCH NEXT FROM B Into @Current
WHILE @@FETCH_STATUS = 0 Begin
SELECT @UserID = NEWID()
SELECT @UserStoreID = NEWID()
SELECT @Name = '# ' + RIGHT(CONVERT(nvarchar(25),@Current),4)
Select @Pass = CONVERT(nvarchar(25),@Current)
--IF (SELECT TOP(1) Password From Users Where Password = @Pass )  = 0 Begin
EXEC	[dbo].[SP_UsersInsert]
		@UserId = @UserID,
		@UserName = @Name,
		@Password = @Pass,
		@UserFName = NULL,
		@UserLName = NULL,
		@Address = NULL,
		@HomePhoneNumber = NULL,
		@WorkPhoneNumber = NULL,
		@Fax = NULL,
		@Email = NULL,
		@ZipCode = NULL,
		@IsSuperAdmin = NULL,
		@Status = 1,
		@ModifierID = NULL

EXEC	[dbo].[SP_UsersStoreInsert]
		@UserStoreID = @UserStoreID,
		@UserID = @UserID,
		@OnLine = NULL,
		@StoreID = @Store,
		@IsDefault = NULL,
		@Manager = NULL,
		@GroupID = @GroupID,
		@LogonDate = NULL,
		@Status = 1,
		@ModifierID = NULL
Print @Pass + ' Inserted'
	--	End
Print @Pass

FETCH NEXT FROM B Into @Current
End
Close B
Deallocate B

Drop Table #MyList
GO