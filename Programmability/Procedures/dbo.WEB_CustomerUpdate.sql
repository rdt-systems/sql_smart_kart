SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_CustomerUpdate](@CustomerID uniqueidentifier,

@FirstName nvarchar(50),
@LastName nvarchar(50),
@MainAddressID uniqueidentifier,
@CustomerType int,
@CreditCardID int,
@CreditCardNO decimal,
@State nvarchar(50),
@Password nvarchar(50),
@OnMailingList bit,
@ModifierID uniqueidentifier,
@FaxNumber nvarchar(20),
@Contact1 nvarchar(50),
@Contact2 nvarchar(50),
@Status smallint)

AS 
Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

update dbo.Customer set
FirstName= dbo.CheckString(@FirstName),
LastName=dbo.CheckString(@LastName),
MainAddressID=@MainAddressID,
CustomerType=@CustomerType,
CreditCardID=@CreditCardID,
CreditCardNO= @CreditCardNO,
State=dbo.CheckString(@State),
[Password]=@Password,
OnMailingList=@OnMailingList,
FaxNumber=@FaxNumber,
Contact1=dbo.CheckString(@Contact1),
Contact2=dbo.CheckString(@Contact2), 
Status=isnull(@Status,1), 
  UserModified=  @ModifierID,
 DateModified =@UpdateTime
    where CustomerID  =@CustomerID
                    
	     
	select @UpdateTime as DateModified

Update Customer Set LoyaltyMemberType =NULL, DateModified =dbo.GetLocalDATE() Where LoyaltyMemberType =0
GO