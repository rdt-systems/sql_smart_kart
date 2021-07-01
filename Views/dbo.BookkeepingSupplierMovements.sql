SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE View [dbo].[BookkeepingSupplierMovements] as

--Bill with tax
select  Movements.DebitAccount as AccountDebit1,
		'מעמת' as AccountDebit2,
		isnull(Supplier.AccountNo,SupplierNo) as AccountCredit1,
		'' as AccountCredit2,
		case when (isnumeric(BillNo)=1) then BillNo else Right(BillNo,(len(BillNo)-charindex('-',BillNo))) end as Reference,
		BillDate as RefDate,
		isnull(BillDue,BillDate) as Due,
		round(Amount,2)-round(TaxAmount,2) as ShekelDebit1,
		round(TaxAmount,2) as ShekelDebit2,
		round(Amount,2) as ShekelCredit1,
		0 as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		Bill.BillID as TransactionID

from Bill 
inner join Supplier on Supplier.SupplierID= Bill.SupplierID
Left outer join Movements on ActionType=7


where		Bill.SupplierID is not null
		and Bill.Status>0
		and Bill.TransferedToBookkeeping=0
		and Amount>0
		and Taxable=1
		and (accountno is not null or isnumeric(supplierNo)=1)

union all

--Bill with out tax
select  Movements.DebitAccount as AccountDebit1,
		'' as AccountDebit2,
		isnull(Supplier.AccountNo,Supplier.SupplierNo) as AccountCredit1,
		'' as AccountCredit2,
		case when (isnumeric(BillNo)=1) then BillNo else Right(BillNo,(len(BillNo)-charindex('-',BillNo))) end as Reference,
		BillDate as RefDate,
		isnull(BillDue,BillDate) as Due,
		Amount as ShekelDebit1,
		0 as ShekelDebit2,
		Amount as ShekelCredit1,
		0 as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		Bill.BillID as TransactionID

from Bill 
inner join Supplier on Supplier.SupplierID= Bill.SupplierID
Left outer join Movements on ActionType=8


where		Bill.SupplierID is not null
		and Bill.Status>0
		and Bill.TransferedToBookkeeping=0
		and Amount>0
		and Taxable=0
		and (accountno is not null or isnumeric(supplierNo)=1)

union all

--Cash payments to supplier
select  isnull(Supplier.AccountNo,Supplier.SupplierNo) as AccountDebit1,
		'' as AccountDebit2,
		Movements.CreditAccount as AccountCredit1,
		'' as AccountCredit2,
		case when (isnumeric(SuppTenderNo)=1) then SuppTenderNo else Right(SuppTenderNo,(len(SuppTenderNo)-charindex('-',SuppTenderNo))) end as Reference,
		TenderDate as RefDate,
		TenderDate as Due,
		Amount as ShekelDebit1,
		0 as ShekelDebit2,
		Amount as ShekelCredit1,
		0 as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		SuppTenderEntryID as TransactionID

from dbo.SupplierTenderEntry
inner join Supplier on Supplier.SupplierID= SupplierTenderEntry.SupplierID
Left outer join Movements on ActionType=9


where		SupplierTenderEntry.SupplierID is not null
		and SupplierTenderEntry.Status>0
		and SupplierTenderEntry.TransferedToBookkeeping=0
		and Amount>0
		and TenderID<>2
		and (accountno is not null or isnumeric(supplierNo)=1)
	

union all

--Check Payments to supplier
select  isnull(Supplier.AccountNo,Supplier.SupplierNo) as AccountDebit1,
		'' as AccountDebit2,
		Movements.CreditAccount as AccountCredit1,
		'' as AccountCredit2,
		case when (isnumeric(SuppTenderNo)=1) then SuppTenderNo else Right(SuppTenderNo,(len(SuppTenderNo)-charindex('-',SuppTenderNo))) end as Reference,
		TenderDate as RefDate,
		isnull(cast ( Common4 as DateTime),TenderDate) as Due,
		Amount as ShekelDebit1,
		0 as ShekelDebit2,
		Amount as ShekelCredit1,
		0 as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		SuppTenderEntryID as TransactionID

from dbo.SupplierTenderEntry
inner join Supplier on Supplier.SupplierID= SupplierTenderEntry.SupplierID
Left outer join Movements on ActionType=10


where		SupplierTenderEntry.SupplierID is not null
		and SupplierTenderEntry.Status>0
		and SupplierTenderEntry.TransferedToBookkeeping=0
		and Amount>0
		and TenderID=2
		and (accountno is not null or isnumeric(supplierNo)=1)
union all 

--Return with tax
select  
		isnull(Supplier.AccountNo,Supplier.SupplierNo) as AccountDebit1,
		'' as AccountDebit2,
		Movements.CreditAccount as AccountCredit1,
		'מעמת' as AccountCredit2,
		case when (isnumeric(ReturnToVenderNo)=1) then ReturnToVenderNo else Right(ReturnToVenderNo,(len(ReturnToVenderNo)-charindex('-',ReturnToVenderNo))) end as Reference,
		ReturnToVender.DateCreated as RefDate,
		ReturnToVender.DateCreated as Due,
		round(Total,2) as ShekelDebit1,
		0 as ShekelDebit2,
		round(Total,2)-round(TaxAmount,2) as ShekelCredit1,
		round(TaxAmount,2) as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		ReturnToVenderID as TransactionID

from dbo.ReturnToVender
inner join Supplier on Supplier.SupplierID= ReturnToVender.SupplierID
Left outer join Movements on ActionType=11


where		ReturnToVender.SupplierID is not null
		and ReturnToVender.Status>0
		and ReturnToVender.TransferedToBookkeeping=0
		and Total>0
		and Taxable=1
		and (accountno is not null or isnumeric(supplierNo)=1)

union all
--Return without tax
select  
		isnull(Supplier.AccountNo,Supplier.SupplierNo) as AccountDebit1,
		'' as AccountDebit2,
		Movements.CreditAccount as AccountCredit1,
		'' as AccountCredit2,
		case when (isnumeric(ReturnToVenderNo)=1) then ReturnToVenderNo else Right(ReturnToVenderNo,(len(ReturnToVenderNo)-charindex('-',ReturnToVenderNo))) end as Reference,
		ReturnToVender.DateCreated as RefDate,
		ReturnToVender.DateCreated as Due,
		Total as ShekelDebit1,
		0 as ShekelDebit2,
		Total as ShekelCredit1,
		0 as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		ReturnToVenderID as TransactionID

from dbo.ReturnToVender
inner join Supplier on Supplier.SupplierID= ReturnToVender.SupplierID
Left outer join Movements on ActionType=12


where		ReturnToVender.SupplierID is not null
		and ReturnToVender.Status>0
		and ReturnToVender.TransferedToBookkeeping=0
		and Total>0
		and Taxable=0
		and (accountno is not null or isnumeric(supplierNo)=1)

--order by MovementType
GO