SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_GetCustomerEmails] 
(@CustomerID uniqueidentifier)
AS
	
SELECT EmailAddress
FROM  Email
WHERE  Status > 0 AND exists
       (SELECT 1 FROM CustomerToEmail
         WHERE  Status > 0 AND CustomerID = @CustomerID and EmailID=Email.EmailID)
GO