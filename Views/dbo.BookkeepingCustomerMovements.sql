SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE View [dbo].[BookkeepingCustomerMovements] as

--invoice with tax
select  isnull(Customer.AccountNo,Customer.CustomerNo) as AccountDebit1,
		'' as AccountDebit2,
		Movements.CreditAccount as AccountCredit1,
		'מעמע' as AccountCredit2,
		case when (isnumeric(TransactionNo)=1) then TransactionNo else Right(TransactionNo,(len(Transactionno)-charindex('-',TransactionNo))) end as Reference,
		[Transaction].StartSaleTime as RefDate,
		isnull([Transaction].DueDate,[Transaction].StartSaleTime) as Due,
		round(Debit,2) as ShekelDebit1,
		0 as ShekelDebit2,
		round(Debit,2)-round(Tax,2) as ShekelCredit1,
		round(Tax,2) as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		[Transaction].TransactionID 

from [Transaction] 
inner join Customer on Customer.CustomerID= [Transaction].CustomerID
Left outer join Movements on ActionType=1


where		[Transaction].TaxID is not null 
		and [Transaction].CustomerID is not null
		and [Transaction].TransactionType=0
		and [Transaction].Status>0
		--and Customer.AccountNo is not null
		and [Transaction].TransferedToBookkeeping=0
		and (accountno is not null or isnumeric(Customer.CustomerNo)=1)
		and Debit>0

union all

--invoice with out tax
select  isnull(Customer.AccountNo,Customer.CustomerNo) as AccountDebit1,
		'' as AccountDebit2,
		Movements.CreditAccount as AccountCredit1,
		'' as AccountCredit2,
		case when (isnumeric(TransactionNo)=1) then TransactionNo else Right(TransactionNo,(len(Transactionno)-charindex('-',TransactionNo))) end as Reference,
		[Transaction].StartSaleTime as RefDate,
		isnull([Transaction].DueDate,[Transaction].StartSaleTime) as Due,
		Debit as ShekelDebit1,
		0 as ShekelDebit2,
		Debit as ShekelCredit1,
		0 as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		[Transaction].TransactionID 

from [Transaction] 
inner join Customer on Customer.CustomerID= [Transaction].CustomerID
Left outer join Movements on ActionType=2


where		[Transaction].TaxID is null 
		and [Transaction].CustomerID is not null
		and [Transaction].TransactionType=0
		and [Transaction].Status>0
		--and Customer.AccountNo is not null
		and [Transaction].TransferedToBookkeeping=0
		and Debit>0
		and (accountno is not null or isnumeric(Customer.CustomerNo)=1)

union all

--Cash Payments
select  Movements.DebitAccount as AccountDebit1,
		'' as AccountDebit2,
		isnull(Customer.AccountNo,Customer.CustomerNo) as AccountCredit1,
		'' as AccountCredit2,
		case when (isnumeric(TransactionNo)=1) then TransactionNo else Right(TransactionNo,(len(Transactionno)-charindex('-',TransactionNo))) end as Reference,
		[Transaction].StartSaleTime as RefDate,
		isnull([Transaction].DueDate,[Transaction].StartSaleTime) as Due,
		Amount as ShekelDebit1,
		0 as ShekelDebit2,
		Amount as ShekelCredit1,
		0 as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		[Transaction].TransactionID 

from	TenderEntry 
		inner join [Transaction] on TenderEntry.TransactionID=[Transaction].TransactionID
		inner join Tender on Tender.TenderID=TenderEntry.TenderID
		inner join Customer on Customer.CustomerID= [Transaction].CustomerID
		Left outer join Movements on ActionType=3

where		Tender.TenderType=2
		and	TenderEntry.TenderID<>2 
		and [Transaction].CustomerID is not null
		and [Transaction].Status>0
		and TenderEntry.Status>0
		--and Customer.AccountNo is not null
		and Amount>0
		and [Transaction].TransferedToBookkeeping=0
		and (accountno is not null or isnumeric(Customer.CustomerNo)=1)
union all

--Check Payments
select  Movements.DebitAccount as AccountDebit1,
		'' as AccountDebit2,
		isnull(Customer.AccountNo,Customer.CustomerNo) as AccountCredit1,
		'' as AccountCredit2,
		case when (isnumeric(TransactionNo)=1) then TransactionNo else Right(TransactionNo,(len(Transactionno)-charindex('-',TransactionNo))) end as Reference,
		[Transaction].StartSaleTime as RefDate,
		isnull([Transaction].DueDate,[Transaction].StartSaleTime) as Due,
		Amount as ShekelDebit1,
		0 as ShekelDebit2,
		Amount as ShekelCredit1,
		0 as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		[Transaction].TransactionID 

from	TenderEntry 
		inner join [Transaction] on TenderEntry.TransactionID=[Transaction].TransactionID
		inner join Customer on Customer.CustomerID= [Transaction].CustomerID
		Left outer join Movements on ActionType=4


where		TenderEntry.TenderID=2 
		and [Transaction].CustomerID is not null
		and [Transaction].Status>0
		and TenderEntry.Status>0
		--and Customer.AccountNo is not null
		and Amount>0
		and [Transaction].TransferedToBookkeeping=0
		and (accountno is not null or isnumeric(Customer.CustomerNo)=1)

union all 

--Return with tax
select  
		Movements.DebitAccount as AccountDebit1,
		'מעמע' as AccountDebit2,
		isnull(Customer.AccountNo,Customer.CustomerNo) as AccountCredit1,
		'' as AccountCredit2,
		case when (isnumeric(TransactionNo)=1) then TransactionNo else Right(TransactionNo,(len(Transactionno)-charindex('-',TransactionNo))) end as Reference,
		[Transaction].StartSaleTime as RefDate,
		isnull([Transaction].DueDate,[Transaction].StartSaleTime) as Due,
		abs(round(Debit,2)+round(Tax,2)) as ShekelDebit1,
		abs(round(Tax,2)) as ShekelDebit2,
		abs(round(Debit,2)) as ShekelCredit1,
		0 as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		[Transaction].TransactionID 

from [Transaction] 
inner join Customer on Customer.CustomerID= [Transaction].CustomerID
Left outer join Movements on ActionType=5


where		[Transaction].TaxID is not null 
		and [Transaction].CustomerID is not null
		and [Transaction].TransactionType=3
		and [Transaction].Status>0
		--and Customer.AccountNo is not null
		and [Transaction].TransferedToBookkeeping=0
		and Debit<0
		and (accountno is not null or isnumeric(Customer.CustomerNo)=1)

union all
--Return without tax
select  
		Movements.DebitAccount as AccountDebit1,
		'' as AccountDebit2,
		isnull(Customer.AccountNo,Customer.CustomerNo) as AccountCredit1,
		'' as AccountCredit2,
		case when (isnumeric(TransactionNo)=1) then TransactionNo else Right(TransactionNo,(len(Transactionno)-charindex('-',TransactionNo))) end as Reference,
		[Transaction].StartSaleTime as RefDate,
		isnull([Transaction].DueDate,[Transaction].StartSaleTime) as Due,
		abs(Debit) as ShekelDebit1,
		0 as ShekelDebit2,		
		abs(Debit) as ShekelCredit1,
		0 as ShekelCredit2,
		'$' as Currency,
		Movements.MovementType,
		[Transaction].TransactionID 

from [Transaction] 
inner join Customer on Customer.CustomerID= [Transaction].CustomerID
Left outer join Movements on ActionType=6


where		[Transaction].TaxID is  null 
		and [Transaction].CustomerID is not null
		and [Transaction].TransactionType=3
		and [Transaction].Status>0
		--and Customer.AccountNo is not null
		and [Transaction].TransferedToBookkeeping=0
		and Debit<0
		and (accountno is not null or isnumeric(Customer.CustomerNo)=1)

--order by MovementType
GO