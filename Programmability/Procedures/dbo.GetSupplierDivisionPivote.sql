SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[GetSupplierDivisionPivote]
(@FromDate datetime,
 @ToDate datetime,
 @UserID uniqueidentifier=NUll)

As

select Sum(isnull(PaymentDetails.Amount,0)) as AmountPaid,Trans.TransactionNo,Trans.EndSaleTime,PaymentDetails.TransactionPayedID,( case When Trans.Debit<>0 then Trans.Debit else 1 end) as Debit,Trans.UserCreated as [User]
into #Temp1
From PaymentDetails 
inner join
  (
  Select Debit ,TransactionID,TransactionNo,EndSaleTime,UserCreated
  from dbo.[Transaction]
  where [Transaction].Status>0 
  group By Debit,TransactionID,TransactionNo,EndSaleTime,UserCreated
  )
  Trans on Trans.TransactionID=PaymentDetails.TransactionPayedID
 inner join
 [transaction] on  [transaction].TransactionID=PaymentDetails.TransactionID

where PaymentDetails.Status>0 and [transaction].Status>0 and ([transaction].UserCreated=@UserID Or @UserID is null) And [transaction].EndSaleTime>=@FromDate and [transaction].EndSaleTime<@ToDate
Group By PaymentDetails.TransactionPayedID,Trans.Debit,Trans.TransactionNo,Trans.EndSaleTime,Trans.UserCreated
having Sum(Amount)>0 

Select  Debit,
		AmountPaid,
		Entry.ExtCost,
		ExtPrice,
		Entry.[Name] as ItemName,
		Supplier.[Name] as SuppName,
		Entry.ExtCost*AmountPaid/Debit As SupplierProfit,
		(AmountPaid/Debit) * (ExtPrice  - Entry.ExtCost)  as MyProfit,
		#Temp1.TransactionPayedID,
		Entry.ItemStoreID,
		#Temp1.TransactionNo,
		#Temp1.EndSaleTime,
		Users.UserFName
from #Temp1 
	inner join (Select Sum(TransactionEntryView.Total) as ExtPrice,Sum(TransactionEntryView.Cost*TransactionEntryView.UomQty) as ExtCost,[Name],TransactionEntryView.ItemStoreID,ItemSupply.SupplierNo,TransactionEntryView.TransactionID
				from TransactionEntryView inner Join 
                     ItemSupply On ItemSupply.ItemStoreNo=TransactionEntryView.ItemStoreID And ItemSupply.Status>-1 And ItemSupply.IsMainSupplier=1
                where TransactionEntryView.Status>0
                Group By TransactionEntryView.ItemStoreID,[Name],TransactionEntryView.TransactionID,ItemSupply.SupplierNo
                Having Sum(TransactionEntryView.Cost*TransactionEntryView.Qty)>0) 
    Entry  On Entry.TransactionID=#Temp1.TransactionPayedID
    inner Join Supplier On Supplier.SupplierID=Entry.SupplierNo
	Inner Join Users On Users.UserId=#Temp1.[User]
order by #Temp1.TransactionPayedID

Drop Table #Temp1
GO