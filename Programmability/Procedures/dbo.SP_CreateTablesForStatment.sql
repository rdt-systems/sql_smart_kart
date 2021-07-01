SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_CreateTablesForStatment]
(@FromDate datetime,
@ToDate datetime,
@StartNo int)
as


select TransactionID,
		@StartNo+(Select count(*) from [transaction]t where EndSaleTime>=@FromDate and TransactionType<>2 and TransactionType<>4 and status>0 and EndSaleTime<[transaction].endsaletime) NewTransactionID,
		CustomerNo
INTO #TempID
FROM [Transaction] inner join 
	Customer on Customer.CustomerID=[Transaction].CustomerID
where EndSaleTime>@FromDate and EndSaleTime<@ToDate and [Transaction].Status>0 and [transaction].TransactionType<>2 and [transaction].TransactionType<>4
order by EndSaleTime

SELECT NewTransactionID as TransactionID,
	TransactionNo,TransactionType,RegisterTransaction,BatchID,StoreID,CustomerNo,Debit,[Transaction].Credit,
	StartSaleTime,EndSaleTime,DueDate,CurrBalance,LeftDebit,Freight,Tax,TaxType,TaxRate,[Transaction].TaxID,
	ShipTo,ShipVia,PONo,RepID,TermsID,PhoneOrder,ToPrint,ToEmail,CustomerMessage,RegisterID,
	RecieptTxt,Note,VoidReason,[Transaction].ResellerID,DeliveryDate,TrackNo,[Transaction].Status,
	[Transaction].DateCreated,[Transaction].UserCreated,[Transaction].DateModified,[Transaction].UserModified
INTO  tranTemp
FROM [Transaction] inner join 
	#TempID on #TempID.TransactionID=[Transaction].TransactionID
where EndSaleTime>@FromDate and EndSaleTime<@ToDate
order by EndSaleTime

select  TransactionEntryID,NewTransactionID as TransactionID,ItemStoreID,Sort,TransactionEntryType,
	Taxable,Qty,UOMPrice,UOMType,UOMQty,Total,RegUnitPrice,DiscountPerc,DiscountAmount,SaleCode,
	PriceExplanation,ParentTransactionEntry,AVGCost,Cost,ReturnReason,Note,DepartmentID,DiscountOnTotal,
	Status,DateCreated,UserCreated,DateModified,UserModified
INTO  tranEntryTemp
from TransactionEntry Inner Join
	#TempID on #TempID.TransactionID=TransactionEntry.TransactionID
where TransactionEntry.Status>0

drop table #TempID
GO