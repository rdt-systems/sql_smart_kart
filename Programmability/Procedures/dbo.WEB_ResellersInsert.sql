SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_ResellersInsert]
(
	@ResellerID	uniqueidentifier,	
	@ResellerLName	nvarchar(50),	
	@ResellerFName	nvarchar(50),	
	@CompanyName	nvarchar(50),	
	@Email	nvarchar(50),	
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
	@Status	smallint
	
)

AS INSERT INTO dbo.Resellers
                      ( ResellerID,ResellerLName,ResellerFName,CompanyName,Email,Phone,Address1,Address2,City,StateID,ZipCode,UserName,[Password],SecurityQ,SecurityA
	         ,DomainName,DomainIP,DesignID,CreditCard4Dig,CreditCardType,CCExpire,BankRoutingNum,BankAccountNum,BankAccountFullName,DriverLicenseStateID,
		BillFullName,BillAddress1,BillAddress2,BillState,BillZip,BillCountry,BillPhone,BillUse,
		Status,DateCreated,DateModified )

VALUES          (@ResellerID,@ResellerLName,@ResellerFName,@CompanyName,@Email,@Phone,@Address1,@Address2,@City,@StateID,@ZipCode,@UserName,@Password,@SecurityQ,@SecurityA,
		@DomainName,@DomainIP,@DesignID,@CreditCard4Dig,@CreditCardType,@CCExpire,@BankRoutingNum,@BankAccountNum,@BankAccountFullName,@DriverLicenseStateID,
		@BillFullName,@BillAddress1,@BillAddress2,@BillState,@BillZip,@BillCountry,@BillPhone,	@BillUse,
		@Status,dbo.GetLocalDATE(),  dbo.GetLocalDATE())
GO