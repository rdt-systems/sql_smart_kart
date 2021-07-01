SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetDivisionByTransaction]
(@Filter nvarchar(4000))
AS

declare @MySelect1 nvarchar(4000)
set @MySelect1= 'SELECT   isnull(sum(dbo.SumAmountPaidByTransaction.SumAmount* dbo.CostByTransactionAndSupplier.SumCost /case When dbo.CostByTransactionAndSupplier.Debit <> 0 then dbo.CostByTransactionAndSupplier.Debit else 1 end),0) AS SumDivision,
                            dbo.CostByTransactionAndSupplier.TransactionID,
                            dbo.CostByTransactionAndSupplier.SupplierNo,
                            dbo.SumAmountPaidByTransaction.DateT
                 FROM        dbo.CostByTransactionAndSupplier Left OUTER JOIN
                            dbo.SumAmountPaidByTransaction ON dbo.CostByTransactionAndSupplier.TransactionID = dbo.SumAmountPaidByTransaction.TransactionID where (1=1)'

declare @MySelect2 nvarchar(4000)
set @MySelect2= 

'GROUP BY dbo.CostByTransactionAndSupplier.TransactionID,dbo.CostByTransactionAndSupplier.SupplierNo, dbo.SumAmountPaidByTransaction.DateT
having isnull(sum(dbo.SumAmountPaidByTransaction.SumAmount* dbo.CostByTransactionAndSupplier.SumCost /case When dbo.CostByTransactionAndSupplier.Debit <> 0 then dbo.CostByTransactionAndSupplier.Debit else 1 end),0)>0'

Execute (@MySelect1 + @Filter + @MySelect2 )
GO