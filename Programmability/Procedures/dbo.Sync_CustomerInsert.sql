SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sync_CustomerInsert]
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
@ModifierID uniqueidentifier)

as

if (SELECT COUNT(*)
	FROM dbo.Customer
	WHERE CustomerID=@CustomerID)>0 RETURN


INSERT INTO dbo.Customer
                   
    (CustomerID,CustomerType,Statment,OnMailingList,CheckAccept,EnforceCheckSign,EnforceCreditLimit,
    CustomerNo,FirstName,LastName,PriceLevelID,FaxNumber,
	Status, DateCreated, UserCreated, DateModified, UserModified)

      

VALUES
    (@CustomerID,2,0,0,0,0,0,
	 @CustomerNo,@FirstName,@LastName,@PriceLevel,(CASE WHEN @FaxNumber='' THEN NULL ELSE @FaxNumber END),
	 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)

exec [Sync_UpdateCustomerAddress] @CustomerID,@Address,@Address2,@City,@State,@Zip,@PhoneNumber,@ModifierID



Update Customer Set LoyaltyMemberType =NULL, DateModified =dbo.GetLocalDATE() Where LoyaltyMemberType =0
GO