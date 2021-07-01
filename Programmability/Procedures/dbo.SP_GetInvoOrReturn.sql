SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create procedure [dbo].[SP_GetInvoOrReturn]
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT   *
				FROM dbo.TransactionLivesView
				WHERE (TransactionType = 0 OR
                       TransactionType = 3) AND (StartSaleTime >=
                          dbo.GetCustomerDateStartBalance(dbo.TransactionLivesView.PID)) '
Execute (@MySelect + @Filter )
GO