SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetWTransactions]
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT   dbo.TransactionWithPaidView.*
		FROM dbo.TransactionWithPaidView
		WHERE  Status>-1  '
Execute (@MySelect + @Filter )
GO