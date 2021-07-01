SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_Wtables_Delete]
AS

DELETE FROM dbo.W_Transaction
WHERE StartSaleTime>dateadd(day ,-7,dbo.GetLocalDATE())

DELETE FROM dbo.W_TenderEntry
WHERE not exists (select 1 from dbo.W_Transaction where W_TenderEntry.transactionid=W_Transaction.transactionid)

DELETE FROM dbo.W_TransactionEntry
WHERE not exists (select 1 from dbo.W_Transaction where W_TransactionEntry.transactionid=W_Transaction.transactionid)
GO