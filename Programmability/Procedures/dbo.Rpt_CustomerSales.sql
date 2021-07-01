SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_CustomerSales]
(
@AVGCost bit =1,
@Filter nvarchar(4000)
)
as
declare @MySelect nvarchar(2000)
declare @Group nvarchar(400)
if @AVGCost=1
begin

set @MySelect='SELECT        CustomerWithAddressView.CustomerID, CustomerWithAddressView.PhoneNumber1, CustomerWithAddressView.PhoneNumber2, CustomerWithAddressView.CustomerNo, CustomerWithAddressView.Credit, 
                         CustomerWithAddressView.Contact1, CustomerWithAddressView.Contact2, CustomerWithAddressView.BalanceDoe, CustomerWithAddressView.FirstName, CustomerWithAddressView.LastName, 
                         CustomerWithAddressView.AllMainDetails, CustomerWithAddressView.City, CustomerWithAddressView.State, CustomerWithAddressView.Zip, tr.TotalAfterDiscount, tr.Discount, tr.TotalSale, tr.Paid, tr.TransCount, 
                         CustomerWithAddressView.Name, tr.Tax, CustomerWithAddressView.Address
FROM            CustomerWithAddressView INNER JOIN
                             (SELECT        [Transaction].CustomerID,  SUM([Transaction].Credit) AS Paid, COUNT([Transaction].TransactionID) AS TransCount, SUM([Transaction].Tax) AS Tax, SUM(TRA.TotalSale) AS TotalSale, SUM(TRA.TotalAfterDiscount) 
                                                         AS TotalAfterDiscount, SUM(TRA.Discount) AS Discount
                               FROM            [Transaction] INNER JOIN
                                (SELECT        TransactionID, SUM(Total) AS TotalSale, SUM(TotalAfterDiscount) AS TotalAfterDiscount,
															  SUM(ISNULL(TransactionEntry.DiscountOnTotal, 0)) AS Discount
                                                               FROM            TransactionEntry Where Status >0
                                                               GROUP BY TransactionID) AS TRA ON [Transaction].TransactionID = TRA.TransactionID
                               WHERE        ([Transaction].TransactionType = 0) AND  ([Transaction].Status > 0) AND ([Transaction].CustomerID IS NOT NULL)  '
	
end
else
begin

set @MySelect='SELECT Name,dbo.CustomerWithAddressView.CustomerID,
	PhoneNumber1, PhoneNumber2, CustomerNo, Credit,
                       Contact1, Contact2, BalanceDoe, Name as CustomerName, FirstName, 
                      LastName, AllMainDetails,Qty,[Ext Price],TotalMargin,TotalTax,TotalDiscount, Paid
	FROM dbo.CustomerWithAddressView INNER JOIN
	(
		select [Transaction].CustomerID,sum(ISNULL(Entry.Qty,0))Qty,Sum(ISNULL(Entry.[Ext Price],0))as [Ext Price],SUM(ISNULL(Entry.TotalMargin,0)) as TotalMargin, SUM(ISNULL(tax,0)) AS TotalTax, SUM(ISNULL([Transaction].Credit,0)) AS Paid,
		sum(dbo.GetTransactionDiscount([Transaction].TransactionID))as TotalDiscount
		from [Transaction]  Inner join CustomerFilter on CustomerFilter.CustomerID = [Transaction].CustomerID inner join 
		(SELECT TransactionID,
		SUM(Qty)as Qty,
		    SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - ISNULL(dbo.TransactionEntry.DiscountAmount, 0)) as [Ext Price],
		    SUM(ISNULL(dbo.TransactionEntry.UOMQty, 1) * dbo.TransactionEntry.UOMPrice - ISNULL(dbo.TransactionEntry.DiscountAmount, 0) - (ISNULL(Cost,0))*Qty) as TotalMargin
		FROM dbo.TransactionEntry  
		WHERE  Status>0 and TransactionEntryType<>4 --discount   
		group by TransactionID)Entry 
		on Entry.TransactionID=[Transaction].TransactionID
		where [Transaction].status>0 and transactiontype=0  '
end

set @Group='  GROUP BY [Transaction].CustomerID) AS tr ON tr.CustomerID = CustomerWithAddressView.CustomerID
WHERE        (CustomerWithAddressView.Status > 0)'

print (@MySelect +@Filter+@Group)

exec(@MySelect +@Filter+@Group)
GO