SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[GetSupplierDivision]
(@FromDate datetime,
 @ToDate datetime)

As

select Sum(isnull(PaymentDetails.Amount,0)) as AmountPaid,PaymentDetails.TransactionPayedID,( case When Trans.Debit<>0 then Trans.Debit else 1 end) as Debit
into #Temp1
From PaymentDetails 
inner join
	(
	Select Debit ,TransactionID
	from dbo.[Transaction]
	where [Transaction].Status>0 
	group By Debit,TransactionID
	) Trans on Trans.TransactionID=PaymentDetails.TransactionPayedID

	inner join
	[transaction] on  [transaction].TransactionID=PaymentDetails.TransactionID

where PaymentDetails.Status>0 and [transaction].Status>0 and [transaction].StartSaleTime>=@FromDate and [transaction].StartSaleTime<@ToDate
Group By PaymentDetails.TransactionPayedID,Trans.Debit
having Sum(Amount)>0 

Select Debit,AmountPaid,Entry.ExtCost*AmountPaid/Debit As AmountDivision,#Temp1.TransactionPayedID,Entry.SupplierNo
into #Temp2
from #Temp1
	inner join (Select Sum(TransactionEntry.Cost*TransactionEntry.Qty) as ExtCost,ItemSupply.SupplierNo,TransactionEntry.TransactionID
		    from TransactionEntry
	     	    	inner Join 
	     	    	ItemSupply On ItemSupply.ItemStoreNo=TransactionEntry.ItemStoreID And ItemSupply.Status>-1 And ItemSupply.IsMainSupplier=1
		    where TransactionEntry.Status>0
		    Group By ItemSupply.SupplierNo,TransactionEntry.TransactionID
		    Having Sum(TransactionEntry.Cost*TransactionEntry.Qty)>0) 
		    Entry  On Entry.TransactionID=#Temp1.TransactionPayedID
order by #Temp1.TransactionPayedID

Select Sum(AmountDivision) As Amount ,Supplier.[Name]  From #Temp2 inner Join Supplier On Supplier.SupplierID=#Temp2.SupplierNo
Group By Supplier.[Name]

Drop Table #Temp1
Drop Table #Temp2
GO