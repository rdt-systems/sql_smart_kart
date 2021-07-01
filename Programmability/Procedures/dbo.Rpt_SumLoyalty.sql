SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_SumLoyalty](
    @Filter nvarchar(4000)
)
as
declare @MySelect nvarchar(2000)
declare @MyGroup nvarchar(1000)

set @MySelect='
 SELECT     COUNT([Transaction].TransactionNo) AS Transacions, Customer.CustomerNo, 
            Customer.LastName + '' '' + ISNULL(Customer.FirstName, '''') AS CustomerName, 
                      SUM(Loyalty.AvailPoints) AS TotalAvelPoints, SUM([Transaction].Debit) AS TotalSales, SUM(Loyalty.Points) AS TotalPoints
FROM         Customer INNER JOIN
                      Loyalty ON Customer.CustomerID = Loyalty.CustomerID INNER JOIN
                      [Transaction] ON Loyalty.TransactionID = [Transaction].TransactionID '
SET @MyGroup = '
GROUP BY Customer.CustomerNo, Customer.LastName, Customer.FirstName ' 

print @MySelect+@Filter+@MyGroup

exec(@MySelect+@Filter+@MyGroup)
GO