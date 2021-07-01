SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_CustomerUpdate]
(
@CustomerID uniqueidentifier,
@CustomerNo nvarchar(50),
@FirstName nvarchar(50),
@LastName nvarchar(50),
@Address nvarchar(50),
@Address2 nvarchar(50),
@City nvarchar(50),
@State nvarchar(50),
@Zip nvarchar(50),
@PhoneNumber nvarchar(50), 
@FaxNumber nvarchar(50),
@PriceLevel nvarchar(50),
@DateModified datetime=null,
@ModifierID uniqueidentifier
)
as

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.Customer
SET
	   CustomerNo = @CustomerNo,
       FirstName = @FirstName,
       LastName = @LastName,
       PriceLevelID =@PriceLevel,
       FaxNumber = (CASE WHEN @FaxNumber='' THEN NULL ELSE @FaxNumber END),
       DateModified=@UpdateTime,
	   UserModified=@ModifierID

WHERE CustomerID=@CustomerID



exec [Sync_UpdateCustomerAddress] @CustomerID,@Address,@Address2,@City,@State,@Zip,@PhoneNumber,@ModifierID

Update Customer Set LoyaltyMemberType =NULL, DateModified =dbo.GetLocalDATE() Where LoyaltyMemberType =0
GO