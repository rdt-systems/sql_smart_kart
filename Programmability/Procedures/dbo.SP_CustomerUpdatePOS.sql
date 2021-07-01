SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_CustomerUpdatePOS]
(@CustomerID uniqueidentifier,
@CustomerNO nvarchar(50),
@FirstName nvarchar(50),
@LastName nvarchar(50),
@MainAddressID uniqueidentifier,
@BirthDay datetime=NULL,
@CustomerType int =3,
@Credit money,
@PriceLevelID int=0,
@TaxExempt bit,
@Email Nvarchar(50),
@LoyaltyMemberType smallint =NULL,
@TaxNumber Nvarchar (25),
@Status smallint=1,
@ModifierID uniqueidentifier
)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()
Declare @vCustomerNO nvarchar(50)



 --IF EXISTS (SELECT * from SetupValues where OPtionID = 429 and StoreID <> '00000000-0000-0000-0000-000000000000' and (OptionValue = '1' Or OptionValue = 'True'))
 --BEGIN
	--SET @AssignCreditLevel = 1
	--SELECT @CreditLevel1 = CASE WHEN ISNULL(@CreditLevel1,0) >0 THEN @CreditLevel1 ELSE  (SELECT TOP(1) OptionValue From SetupValues where OPtionID = 430 and StoreID <> '00000000-0000-0000-0000-000000000000' ) END
	--SELECT @CreditLevel2 =  CASE WHEN ISNULL(@CreditLevel2,0) >0 THEN @CreditLevel2 ELSE  (SELECT TOP(1) OptionValue From SetupValues where OPtionID = 431 and StoreID <> '00000000-0000-0000-0000-000000000000' ) END
	--SELECT @CreditLevel3 = CASE WHEN ISNULL(@CreditLevel3,0) >0 THEN @CreditLevel3 ELSE  (SELECT TOP(1) OptionValue From SetupValues where OPtionID = 432 and StoreID <> '00000000-0000-0000-0000-000000000000' ) END
 --END

IF (SELECT COUNT(*) FROM CUSTOMER WHERE CustomerNo=@CustomerNO AND CustomerID <> @CustomerID And status>0)>0
	SET @vCustomerNO =NULL
ELSE
BEGIN
	IF (SELECT COUNT(*) FROM CUSTOMER WHERE CustomerNo=@CustomerNO AND CustomerID <> @CustomerID And status<1)>0
	BEGIN
	  UPDATE Customer SET CUstomerNo=CUstomerNo +'XX' WHERE CustomerNo=@CustomerNO AND CustomerID <> @CustomerID 
	END
	SET @vCustomerNO =@CustomerNO
END


UPDATE dbo.Customer
SET CustomerNO = ISNULL(@vCustomerNO,CustomerNO) ,
  FirstName= dbo.CheckString(@FirstName),
  LastName= dbo.CheckString(@LastName),
  MainAddressID= @MainAddressID,
  BirthDay= @BirthDay, 
  CustomerType = @CustomerType,
  Credit= @Credit,
  TaxNumber = @TaxNumber ,
  TaxExempt=@TaxExempt,
  Email = @Email,
  LoyaltyMemberType=@LoyaltyMemberType,
  Status=isnull(@Status,1),
  DateModified=@UpdateTime,
  UserModified= @ModifierID
WHERE (CustomerID =@CustomerID) 



--Update Customer Set LoyaltyMemberType =NULL, DateModified =dbo.GetLocalDATE() Where LoyaltyMemberType =0
GO