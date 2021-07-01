SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_RegCustomerUpdate]
(@CustomerID uniqueidentifier,
@CustomerNO nvarchar(50),
@FirstName nvarchar(50),
@LastName nvarchar(50),
@ClubID uniqueidentifier,
@MainAddressID uniqueidentifier,
@SalesPersonID uniqueidentifier,
@SortOrder bigint,
@BirthDay datetime,
@CustomerType int,
@TaxID uniqueidentifier,
@Credit money,
@CreditLevel1 money,
@CreditLevel2 money,
@CreditLevel3 money,
@TermDiscount decimal(18),
@CreditCardID int,
@PriceLevelID int,
@CreditCardNO nvarchar(20),
@TermDays int,
@CSV nvarchar(20),
@CCExpDate datetime,
@DriverLicenseNo nvarchar(50),
@State nvarchar(50),
@SocialSecurytyNO nvarchar(50),
@Password nvarchar(50),
@Statment bit,
@CheckAccept bit,
@EnforceCreditLimit bit,
@EnforceCheckSign bit,
@OnMailingList bit,
@FaxNumber nvarchar(20),
@Contact1 nvarchar(50),
@Contact2 nvarchar(50),
@DiscountID uniqueidentifier,
@DefaultTerms uniqueidentifier,
@TaxExempt bit,
@FoodStampNo nvarchar(50),
@FoodStampCode nvarchar(50),
@LockAccount bit,
@LockOutDays int,
@Status smallint,
@BalanceDoe money,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.Customer

SET CustomerNO = @CustomerNO ,FirstName= @FirstName,LastName= @LastName,ClubID= @ClubID,MainAddressID= 
@MainAddressID,SalesPersonID= @SalesPersonID,SortOrder= @SortOrder,BirthDay= @BirthDay, 
CustomerType = @CustomerType,
TaxID= @TaxID,
Credit= @Credit,
CreditLevel1=@CreditLevel1 ,
CreditLevel2=@CreditLevel2 ,
CreditLevel3=@CreditLevel3 ,
TermDiscount= @TermDiscount, 
CreditCardID=@CreditCardID,
PriceLevelID= @PriceLevelID,
CreditCardNO= @CreditCardNO,
TermDays= @TermDays,
CSV= @CSV,
CCExpDate = @CCExpDate,
DriverLicenseNo= @DriverLicenseNo,
State= @State,
SocialSecurytyNO= @SocialSecurytyNO,
[Password]= @Password, 
Statment= @Statment,
CheckAccept= @CheckAccept,
EnforceCreditLimit= @EnforceCreditLimit,
EnforceCheckSign= @EnforceCheckSign,
OnMailingList=@OnMailingList,
FaxNumber =@FaxNumber,
Contact1=@Contact1,
Contact2=@Contact2,
DiscountID=@DiscountID,
DefaultTerms=@DefaultTerms,
TaxExempt=@TaxExempt,
FoodStampNo=@FoodStampNo,
FoodStampCode=@FoodStampCode,
LockAccount=@LockAccount,
LockOutDays=@LockOutDays,
Status=@Status,
BalanceDoe=@BalanceDoe,
DateModified=@UpdateTime,
UserModified= @ModifierID


WHERE (CustomerID =@CustomerID) AND 
      (DateModified = @DateModified OR DateModified IS NULL) 





select @UpdateTime as DateModified


Update Customer Set LoyaltyMemberType =NULL, DateModified =dbo.GetLocalDATE() Where LoyaltyMemberType =0
GO