SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_GetCustomerCardDetails] 
(@CustomerID uniqueidentifier)
AS
	
SELECT    CreditCardID,CreditCardNo,CCExpDate,SocialSecurytyNO,CreditNameOn
FROM         Customer
WHERE     (Status > 0) AND (CustomerID = @CustomerID)
GO