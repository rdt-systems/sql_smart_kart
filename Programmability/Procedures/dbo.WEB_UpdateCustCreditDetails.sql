SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_UpdateCustCreditDetails]
(@CreditCardID int,
 @CreditCardNo nvarchar(50),
 @CCExpDate datetime,
 @CreditNameOn nvarchar(50),
 @SocialSecurytyNO nvarchar(50),
 @CustomerID uniqueidentifier
)
AS
	update customer
	set 
	CreditCardID=@CreditCardID,
	CreditCardNo=@CreditCardNo,
	CCExpDate=@CCExpDate,
	CreditNameOn=@CreditNameOn,
	SocialSecurytyNO=@SocialSecurytyNO
, datemodified=dbo.GetLocalDATE()
	where CustomerID = @CustomerID
GO