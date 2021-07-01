SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_CustomerTypeSummary] 
(
@AVGCost bit =0,
@Filter nvarchar(4000)=''
)
as
declare @MySelect nvarchar(4000)
declare @Group nvarchar(200)
if @AVGCost=1
begin

set @MySelect='SELECT dbo.SystemValues.SystemValueName AS [Customer Type], SUM(dbo.TransactionEntry.Qty) AS Qty,
		    SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - 
			ISNULL(dbo.TransactionEntry.DiscountAmount, 0)) as [Ext Price],
		    100-(Sum(ISNULL(AVGCost,ISNULL(Cost,0)) *ISNULL(dbo.TransactionEntry.Qty, 1))
		    /case when( 
			SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - 
			ISNULL(dbo.TransactionEntry.DiscountAmount, 0))) =0 then 1 else
			( SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - 
			ISNULL(dbo.TransactionEntry.DiscountAmount, 0)))
			end *100)as TotalMargin
FROM         dbo.SystemTables INNER JOIN
                      dbo.SystemValues ON dbo.SystemTables.SystemTableId = dbo.SystemValues.SystemTableNo INNER JOIN
                      dbo.Customer ON dbo.SystemValues.SystemValueNo = dbo.Customer.CustomerType INNER JOIN
                      dbo.[Transaction] ON dbo.Customer.CustomerID = dbo.[Transaction].CustomerID INNER JOIN
                      dbo.TransactionEntry ON dbo.[Transaction].TransactionID = dbo.TransactionEntry.TransactionID
'
  

end

else
begin

set @MySelect='SELECT dbo.SystemValues.SystemValueName AS [Customer Type], SUM(dbo.TransactionEntry.Qty) AS Qty,
		    SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - 
			ISNULL(dbo.TransactionEntry.DiscountAmount, 0)) as [Ext Price],
		    100-(Sum(ISNULL(Cost,0) *ISNULL(dbo.TransactionEntry.Qty, 1))
		    /case when( 
			SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - 
			ISNULL(dbo.TransactionEntry.DiscountAmount, 0))) =0 then 1 else
			( SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - 
			ISNULL(dbo.TransactionEntry.DiscountAmount, 0)))
			end *100)as TotalMargin
FROM         dbo.SystemTables INNER JOIN
                      dbo.SystemValues ON dbo.SystemTables.SystemTableId = dbo.SystemValues.SystemTableNo INNER JOIN
                      dbo.Customer ON dbo.SystemValues.SystemValueNo = dbo.Customer.CustomerType INNER JOIN
                      dbo.[Transaction] ON dbo.Customer.CustomerID = dbo.[Transaction].CustomerID INNER JOIN
                      dbo.TransactionEntry ON dbo.[Transaction].TransactionID = dbo.TransactionEntry.TransactionID
 '


end

set @Group='where (dbo.SystemTables.SystemTableName = N''customerType'') and [transaction].status>-1 and transactiontype=0  and Customer.Status>0
GROUP BY dbo.SystemValues.SystemValueName'
exec(@MySelect+@Filter+@Group)
GO