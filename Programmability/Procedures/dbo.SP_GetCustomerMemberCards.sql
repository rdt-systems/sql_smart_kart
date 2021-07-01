SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SP_GetCustomerMemberCards] 
(@CustomerID uniqueidentifier)
AS
	
SELECT *
FROM  CustomerMemberCards
WHERE  Status > 0 AND CustomerID=@CustomerID
GO