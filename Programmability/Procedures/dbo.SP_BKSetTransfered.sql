SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE Procedure [dbo].[SP_BKSetTransfered] as
	update [Transaction]
	set TransferedToBookkeeping=1
	where exists (select 1 from BookkeepingCustomerMovements where TransactionID=[transaction].TransactionID)


	update Bill
	set TransferedToBookkeeping=1
	where exists (select 1 from BookkeepingSupplierMovements where TransactionID=Bill.BillID)


	update ReturnToVender
	set TransferedToBookkeeping=1
	where exists (select 1 from BookkeepingSupplierMovements where TransactionID=ReturnToVender.ReturnToVenderID)


	update SupplierTenderEntry
	set TransferedToBookkeeping=1
	where exists (select 1 from BookkeepingSupplierMovements where TransactionID=SupplierTenderEntry.SuppTenderEntryID)
GO