SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetUnTransferedChecks]
(@Filter nvarchar(4000)='')
as
declare @Sel  nvarchar(1000)
set @sel='select TenderEntryID,
		TransactionNo,
		CustomerNo,
		FirstName,
		LastName,
		Amount,
		Common1 as CheckNo,
		Common2 as SubsidiaryNo,
		Common3 as BankNo,
		EndSaleTime as PaymentDate,
		isnull(TenderDate,EndSaleTime) as DueDate,
		1 as Transfer
from TenderEntry
Inner Join [Transaction] On TenderEntry.TransactionID=[Transaction].TransactionID
Inner Join Customer On Customer.CustomerID=[Transaction].CustomerID

where   TenderEntry.Status>0
	and [Transaction].Status>0
	and TenderEntry.TenderID=2
	and isnull(TenderDate,EndSaleTime)<dbo.GetLocalDATE()
	and not exists (select 1 from BookkeepingChecks where TenderEntryID=TenderEntry.TenderEntryID) '

execute (@sel + @Filter)
	
--ALTER procedure SP_TransferCheck
--(@TenderEntryID uniqueidentifier)
--as
--insert into BookkeepingChecks values(@TenderEntryID)
GO