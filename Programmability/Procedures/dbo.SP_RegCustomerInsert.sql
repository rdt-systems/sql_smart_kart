SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_RegCustomerInsert](@CustomerID uniqueidentifier,
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
@Status smallint,
@BalanceDoe money)

AS INSERT INTO dbo.Customer
                      (CustomerID, CustomerNo, FirstName, LastName, ClubID, MainAddressID, SalesPersonID, SortOrder, BirthDay, CustomerType, TaxID, 
                      Credit,  CreditLevel1, CreditLevel2, CreditLevel3,  TermDiscount, CreditCardID, PriceLevelID, CreditCardNO, TermDays, CSV, CCExpDate, 
                      DriverLicenseNo, State, SocialSecurytyNO, Password, Statment, CheckAccept, EnforceCreditLimit, EnforceCheckSign, OnMailingList, FaxNumber, Contact1, Contact2,DiscountID,DefaultTerms, 
	         TaxExempt ,FoodStampNo ,FoodStampCode ,LockAccount ,LockOutDays ,Status, 
                      DateCreated, UserCreated, DateModified, UserModified,BalanceDoe)
VALUES     (@CustomerID, @CustomerNO, @FirstName, @LastName, @ClubID, @MainAddressID, @SalesPersonID, @SortOrder, @BirthDay, 
                      @CustomerType, @TaxID, @Credit, @CreditLevel1, @CreditLevel2, @CreditLevel3,  @TermDiscount, @CreditCardID, @PriceLevelID, 
                      @CreditCardNO, @TermDays, @CSV, @CCExpDate, @DriverLicenseNo, @State, @SocialSecurytyNO, @Password, @Statment, @CheckAccept, 
                      @EnforceCreditLimit, @EnforceCheckSign, @OnMailingList, @FaxNumber, @Contact1, @Contact2,@DiscountID,@DefaultTerms, 
	         @TaxExempt ,@FoodStampNo ,@FoodStampCode ,@LockAccount ,@LockOutDays ,
		1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID,@BalanceDoe)

Update Customer Set LoyaltyMemberType =NULL, DateModified =dbo.GetLocalDATE() Where LoyaltyMemberType =0
GO