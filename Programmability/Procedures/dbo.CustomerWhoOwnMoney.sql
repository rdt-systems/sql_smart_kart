SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[CustomerWhoOwnMoney]
(@LowerBalance decimal=0)
AS
SELECT    ISNULL(dbo.Customer.LastName, '') 
                      + ISNULL(', ' + CASE WHEN dbo.Customer.FirstName = '' THEN NULL ELSE dbo.Customer.FirstName END, ' ')as Name, CustomerNo,BalanceDoe as Balance,CustomerID 
FROM         dbo.Customer
where Round(BalanceDoe,2)>=@LowerBalance and Status>0
GO