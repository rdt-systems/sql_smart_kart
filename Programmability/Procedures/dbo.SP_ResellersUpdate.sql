SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ResellersUpdate]
(
	@ResellerID	uniqueidentifier,	
	@ResellerLName	nvarchar(50),	
	@ResellerFName	nvarchar(50),	
	@CompanyName	nvarchar(50),	
	@Email	nvarchar(50),	
	@OnlyText bit =0,
	@Phone	nvarchar(50),	
	@Address1	nvarchar(50),	
	@Address2	nvarchar(50),	
	@City	nvarchar(50),	
	@StateID	nvarchar(50),	
	@ZipCode	nvarchar(50),	
	@UserName	nvarchar(50),	
	@Password	nvarchar(50),	
	@SecurityQ	nvarchar(50),	
	@SecurityA	nvarchar(50),	
	@DomainName	nvarchar(50),	
	@DomainIP	nvarchar(50),	
	@DesignID	smallint,		
	@CreditCard4Dig	nvarchar(50),		
	@CreditCardType	smallint,		
	@CCExpire	datetime,	
	@SecurityCode nvarchar(50),	
	@BankRoutingNum	nvarchar(50),
	@BankAccountNum	nvarchar(50),
	@BankAccountFullName	nvarchar(50),
	@DriverLicenseStateID	nvarchar(50),
	@BillFullName	nvarchar(50),	
   	@BillAddress1	nvarchar(50),		
	@BillAddress2	nvarchar(50),		
	@BillState	nvarchar(50),		
	@BillZip        nvarchar(50),	
	@BillCountry	nvarchar(50),		
	@BillPhone	nvarchar(50),	
	@BillUse bit,	
 	@CommissionPercents decimal ,
	@LastRegisteredDate datetime,
	@Status smallint,
	@DateModified datetime=null,
	@ModifierID uniqueidentifier=null)
	
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


UPDATE dbo.Resellers

 SET  

ResellerID=@ResellerID,
ResellerLName=@ResellerLName,
ResellerFName=@ResellerFName,
CompanyName=@CompanyName,
Email=@Email,
OnlyText=@OnlyText,
Phone=@Phone,
Address1=@Address1,
Address2=@Address2,
City=@City,
StateID=@StateID,
ZipCode=@ZipCode,
UserName=@UserName,
Password=@Password,
SecurityQ=@SecurityQ,
SecurityA=@SecurityA,
DomainName=@DomainName,
DomainIP=@DomainIP,@DesignID=@DesignID,
CreditCard4Dig=@CreditCard4Dig,
CreditCardType=@CreditCardType,
CCExpire=@CCExpire,
SecurityCode=@SecurityCode,
BankRoutingNum=@BankRoutingNum,
BankAccountNum=@BankAccountNum,
BankAccountFullName=@BankAccountFullName,
DriverLicenseStateID=@DriverLicenseStateID,

BillFullName=@BillFullName,
BillAddress1=@BillAddress1,
BillAddress2=@BillAddress2,
BillState=@BillState,
BillZip=@BillZip,
BillCountry=@BillCountry,
BillPhone=@BillPhone,
BillUse=@BillUse,
LastRegisteredDate=@LastRegisteredDate,
CommissionPercents=@CommissionPercents,
Status = @Status,
DateModified = @UpdateTime,
UserModified=@ModifierID


WHERE  (ResellerID = @ResellerID) AND 
      (DateModified = @DateModified OR DateModified IS NULL or @DateModified is null) 
 
select @UpdateTime as DateModified
GO