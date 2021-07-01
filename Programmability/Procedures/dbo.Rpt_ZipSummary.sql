SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_ZipSummary] 
(
@AVGCost bit =0,
@Filter nvarchar(4000)=''
)
as
declare @MySelect nvarchar(4000)
declare @Group nvarchar(200)
if @AVGCost=1
begin

set @MySelect='SELECT dbo.CustomerAddresses.Zip, SUM(dbo.TransactionEntry.Qty) AS Qty,
		    SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - ISNULL(dbo.TransactionEntry.DiscountAmount, 0)) as [Ext Price],
		    100-(Sum(ISNULL(AVGCost,ISNULL(Cost,0)) *ISNULL(dbo.TransactionEntry.Qty, 1))
		    /case when SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - 
				ISNULL(dbo.TransactionEntry.DiscountAmount, 0))=0 then 1 
				else SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - 
				ISNULL(dbo.TransactionEntry.DiscountAmount, 0)) end
				*100)as TotalMargin
FROM         dbo.TransactionEntry INNER JOIN
                      dbo.[Transaction] ON dbo.TransactionEntry.TransactionID = dbo.[Transaction].TransactionID RIGHT OUTER JOIN
                      dbo.CustomerAddresses RIGHT OUTER JOIN
                      dbo.Customer ON dbo.CustomerAddresses.CustomerAddressID = dbo.Customer.MainAddressID ON 
                      dbo.[Transaction].CustomerID = dbo.Customer.CustomerID
where [transaction].status>-1 and transactiontype=0 And Customer.Status>0 '

end

else
begin

set @MySelect='SELECT     dbo.CustomerAddresses.Zip, SUM(dbo.TransactionEntry.Qty) AS Qty,
		    SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - ISNULL(dbo.TransactionEntry.DiscountAmount, 0)) as [Ext Price],
		    100-(Sum(ISNULL(Cost,0) *ISNULL(dbo.TransactionEntry.Qty, 1))
		    /case when SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - 
				ISNULL(dbo.TransactionEntry.DiscountAmount, 0))=0 then 1 
				else SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - 
				ISNULL(dbo.TransactionEntry.DiscountAmount, 0)) end
				*100)as TotalMargin
FROM         dbo.TransactionEntry INNER JOIN
                      dbo.[Transaction] ON dbo.TransactionEntry.TransactionID = dbo.[Transaction].TransactionID RIGHT OUTER JOIN
                      dbo.CustomerAddresses RIGHT OUTER JOIN
                      dbo.Customer ON dbo.CustomerAddresses.CustomerAddressID = dbo.Customer.MainAddressID ON 
                      dbo.[Transaction].CustomerID = dbo.Customer.CustomerID
where [transaction].status>-1 and transactiontype=0 And Customer.Status>0 '

end

set @Group=' GROUP BY dbo.CustomerAddresses.Zip'
exec(@MySelect+@Filter+@Group)
GO