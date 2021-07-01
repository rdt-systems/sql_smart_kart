SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerContactUpdate]
(@CustomerContactID uniqueidentifier,
@CustomerID uniqueidentifier,
@FirstName nvarchar(50),
@LastName nvarchar(50),
@SortOrder smallint,
@Password nvarchar(50),
@CardMember nvarchar(50),
@Phone1 nvarchar(20),
@Phone2 nvarchar(20),
@Emeil nvarchar(20),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

 UPDATE    dbo.CustomerContact
        
           
    SET     CustomerID=@CustomerID, FirstName=dbo.CheckString(@FirstName), LastName=dbo.CheckString(@LastName), SortOrder=@SortOrder,
                [Password] =@Password,   CardMember= @CardMember,              Phone1 =@Phone1, Phone2 =@Phone2 , Emeil =@Emeil , Status 

= @Status, DateModified=@UpdateTime


WHERE (CustomerContactID=@CustomerContactID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)




select @UpdateTime as DateModified
GO