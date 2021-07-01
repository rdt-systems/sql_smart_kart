SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_CustomerUpdate]
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
@LoyaltyMemberType smallint =NULL,
@NoBalance bit = 0,
@TaxNumber Nvarchar (25),
@ExpDiscount datetime =null,
@DayOfMounth int =0,
@RegularPaymentType int,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@StoreCreated Uniqueidentifier=null,
@note Nvarchar (4000) =null)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


 IF EXISTS (SELECT * from SetupValues where OPtionID = 429 and StoreID <> '00000000-0000-0000-0000-000000000000' and (OptionValue = '1' Or OptionValue = 'True'))
 BEGIN
	SET @AssignCreditLevel = 1
	SELECT @CreditLevel1 = CASE WHEN ISNULL(@CreditLevel1,0) >0 THEN @CreditLevel1 ELSE  (SELECT TOP(1) OptionValue From SetupValues where OPtionID = 430 and StoreID <> '00000000-0000-0000-0000-000000000000' ) END
	SELECT @CreditLevel2 =  CASE WHEN ISNULL(@CreditLevel2,0) >0 THEN @CreditLevel2 ELSE  (SELECT TOP(1) OptionValue From SetupValues where OPtionID = 431 and StoreID <> '00000000-0000-0000-0000-000000000000' ) END
	SELECT @CreditLevel3 = CASE WHEN ISNULL(@CreditLevel3,0) >0 THEN @CreditLevel3 ELSE  (SELECT TOP(1) OptionValue From SetupValues where OPtionID = 432 and StoreID <> '00000000-0000-0000-0000-000000000000' ) END
 END


UPDATE dbo.Customer

SET CustomerNO = dbo.CheckString(@CustomerNO) ,FirstName= dbo.CheckString(@FirstName),LastName= dbo.CheckString(@LastName),ClubID= @ClubID,MainAddressID= 
@MainAddressID,SalesPersonID= @SalesPersonID,SortOrder= @SortOrder,BirthDay= @BirthDay, 
CustomerType = @CustomerType,
TaxID= @TaxID,
Credit= @Credit,
AssignCreditLevel=@AssignCreditLevel,
CreditLevel1=@CreditLevel1 ,
CreditLevel2=@CreditLevel2 ,
CreditLevel3=@CreditLevel3 ,
CreditOnDelivery=@CreditOnDelivery,
TermDiscount= @TermDiscount, 
CreditCardID=@CreditCardID,
PriceLevelID= @PriceLevelID,
CreditCardNO= @CreditCardNO,
TermDays= @TermDays,
CSV= @CSV,
CCExpDate = @CCExpDate,
DriverLicenseNo= @DriverLicenseNo,
TaxNumber = @TaxNumber ,
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
CreditNameOn=@CreditNameOn,
CreditZip=@CreditZip,
ResellerID=@ResellerID,
AccountNo=@AccountNo,
Email = @Email,
SOTerms=@SOTerms,
LoyaltyMemberType=@LoyaltyMemberType,
NoBalance=@NoBalance,
ExpDiscount=@ExpDiscount,
DayOfMounth=@DayOfMounth,
RegularPaymentType=@RegularPaymentType,
Status=isnull(@Status,1),
DateModified=@UpdateTime,
UserModified= @ModifierID,
StoreCreated =@StoreCreated
WHERE (CustomerID =@CustomerID) 
--AND (DateModified = @DateModified OR DateModified IS NULL) 





select @UpdateTime as DateModified

Update Customer Set LoyaltyMemberType =NULL, DateModified =dbo.GetLocalDATE() Where LoyaltyMemberType =0


if @Status =1 
begin 
update CustomerAddresses
set Status=1
where 1=1
and Customerid =@CustomerID
and  Customerid	in(
select Customerid
from Customer
where status=1
and exists(
select 1
from CustomerAddresses
where CustomerAddresses.Customerid =Customer.CustomerID
and Status=0
)
and not exists(
select 1
from CustomerAddresses
where CustomerAddresses.Customerid =Customer.CustomerID
and Status=1
))
and status=0
end 


declare @noteId uniqueidentifier

select top 1 @noteId= NoteId 
from customerNotes
where CustomerID=@CustomerID
and status=1
order by  datecreated desc

if @note is not null 
begin 
if @noteId is null 
	begin 
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
end
else
	begin 
	update customerNotes 
	set NoteValue =@note 
	where NoteId =@NoteId
	end 
end
else 
begin 
update customerNotes 
set NoteValue =@note 
where NoteId =@NoteId
end
GO