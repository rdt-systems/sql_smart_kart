SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_GetCustomerReseller] 
(@CustomerID uniqueidentifier)
AS
	
SELECT    Customer.ResellerID,DesignID,DomainName
FROM         Customer
INNER JOIN resellers on customer.ResellerID=resellers.ResellerID
AND resellers.status>0
WHERE     (Customer.Status > 0) AND (Customer.CustomerID = @CustomerID)
GO