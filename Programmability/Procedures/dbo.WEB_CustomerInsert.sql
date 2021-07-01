SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_CustomerInsert]
(@CustomerID uniqueidentifier,
@FirstName nvarchar(50),
@LastName nvarchar(50),
@Password nvarchar(50),
@Email nvarchar(50),
@CustomerNo nvarchar(50),
@ResellerID uniqueidentifier,
@ModifierID uniqueidentifier,
@Status smallint)
AS  


 INSERT INTO dbo.Customer
                      (CustomerID,CustomerNo,  FirstName, LastName, [Password], CustomerType,  ResellerID,
	          Status,  DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@CustomerID,@CustomerNo,  dbo.CheckString(@FirstName), dbo.CheckString(@LastName), @Password,   4,@ResellerID,
isnull(@Status,1), dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)

declare @id  uniqueidentifier
set @id=newid()

insert into dbo.Email
(emailid,emailaddress,status,datemodified)
values (@id,@email,1, dbo.GetLocalDATE())

insert into dbo.CustomerToEmail(CustomerToEmailID,CustomerID,EmailID,Status,DateModified)
values(newid(),@CustomerID,@id,1,dbo.GetLocalDATE())
GO