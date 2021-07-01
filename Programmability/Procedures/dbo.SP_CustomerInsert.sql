SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_CustomerInsert](@CustomerID uniqueidentifier,
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
@Credit money = 0,
@AssignCreditLevel bit,
@CreditLevel1 money,
@CreditLevel2 money,
@CreditLevel3 money,
@CreditOnDelivery money,
@TermDiscount decimal(18),
@CreditCardID int,
@PriceLevelID int,
@CreditCardNO nvarchar(500),
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
@ModifierID uniqueidentifier,
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
@CreditNameOn Nvarchar(50),
@CreditZip Varchar(10),
@ResellerID Uniqueidentifier,
@AccountNo nvarchar(8),
@Email Nvarchar(50),
@SOTerms int,
@LoyaltyMemberType smallint, 
@NoBalance bit = 0,
@ExpDiscount DateTime = null,
@TaxNumber Nvarchar (25),
@Status smallint,
@DayOfMounth int =0,
@RegularPaymentType int =0,
@StoreCreated Uniqueidentifier=null,
@note Nvarchar (4000) = NULL)



AS 

declare @NO varchar(50)
SET @No= @CustomerNO
while (Select Count(*) from Customer where CustomerNo =@no)>0
 Set @NO= @NO + 'X'



  IF EXISTS (SELECT * from SetupValues where OPtionID = 429 and StoreID <> '00000000-0000-0000-0000-000000000000' and (OptionValue = '1' Or OptionValue = 'True'))
 BEGIN
	SET @AssignCreditLevel = 1
	SELECT @CreditLevel1 = CASE WHEN ISNULL(@CreditLevel1,0) >0 THEN @CreditLevel1 ELSE  (SELECT TOP(1) OptionValue From SetupValues where OPtionID = 430 and StoreID <> '00000000-0000-0000-0000-000000000000' ) END
	SELECT @CreditLevel2 =  CASE WHEN ISNULL(@CreditLevel2,0) >0 THEN @CreditLevel2 ELSE  (SELECT TOP(1) OptionValue From SetupValues where OPtionID = 431 and StoreID <> '00000000-0000-0000-0000-000000000000' ) END
	SELECT @CreditLevel3 = CASE WHEN ISNULL(@CreditLevel3,0) >0 THEN @CreditLevel3 ELSE  (SELECT TOP(1) OptionValue From SetupValues where OPtionID = 432 and StoreID <> '00000000-0000-0000-0000-000000000000' ) END
 END



INSERT INTO dbo.Customer
                      (CustomerID, CustomerNo, FirstName, LastName, ClubID, MainAddressID, SalesPersonID, SortOrder, BirthDay, CustomerType, TaxID, 
                      Credit, AssignCreditLevel,  CreditLevel1, CreditLevel2, CreditLevel3, CreditOnDelivery,  TermDiscount, CreditCardID, PriceLevelID, CreditCardNO, TermDays, CSV, CCExpDate, 
                      DriverLicenseNo, State, SocialSecurytyNO, Password, Statment, CheckAccept, EnforceCreditLimit, EnforceCheckSign, OnMailingList, FaxNumber, Contact1, Contact2,DiscountID,DefaultTerms, 
					  TaxExempt ,FoodStampNo ,FoodStampCode ,LockAccount ,LockOutDays ,CreditNameOn,CreditZip, ResellerID,AccountNo,SOTerms,Email,LoyaltyMemberType,NoBalance,TaxNumber ,ExpDiscount,DayOfMounth ,RegularPaymentType,
					  Status,DateCreated, UserCreated, DateModified, UserModified,StoreCreated)
VALUES     (@CustomerID, dbo.CheckString(@NO), dbo.CheckString(@FirstName), dbo.CheckString(@LastName), @ClubID, @MainAddressID, @SalesPersonID, @SortOrder, @BirthDay, @CustomerType, @TaxID, 
					  @Credit, @AssignCreditLevel, @CreditLevel1, @CreditLevel2, @CreditLevel3,@CreditOnDelivery,  @TermDiscount, @CreditCardID, @PriceLevelID,  @CreditCardNO, @TermDays, @CSV, @CCExpDate, 
					  @DriverLicenseNo, dbo.CheckString(@State), @SocialSecurytyNO, @Password, @Statment, @CheckAccept, @EnforceCreditLimit, @EnforceCheckSign, @OnMailingList, @FaxNumber, dbo.CheckString(@Contact1), dbo.CheckString(@Contact2),@DiscountID,@DefaultTerms, 
					  @TaxExempt ,@FoodStampNo ,@FoodStampCode ,@LockAccount ,@LockOutDays ,@CreditNameOn,@CreditZip, @ResellerID,@AccountNo, @SOTerms,@Email,@LoyaltyMemberType,@NoBalance,@TaxNumber,@ExpDiscount,@DayOfMounth,@RegularPaymentType,
					  isnull(@Status,1), dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID,@StoreCreated)

--Update Customer Set LoyaltyMemberType =NULL, DateModified =dbo.GetLocalDATE() Where LoyaltyMemberType =0




insert into customerNotes
(NoteID,
CustomerID,
TypeOfNote,
NoteValue,
Status,
DateCreated,
UserCreated,
DateModified,
UserModified)
values (
newid(),
@CustomerID,
0,
@note,
1,
dbo.GetLocalDATE(),
@ModifierID,
dbo.GetLocalDATE(),
@ModifierID
)
GO