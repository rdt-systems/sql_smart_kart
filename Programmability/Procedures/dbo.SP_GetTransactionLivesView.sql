SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetTransactionLivesView]
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT   dbo.TransactionLivesView.*, ABS (isnull(Debit,0)-IsNull(Credit,0)) as Total
		FROM dbo.TransactionLivesView
		WHERE  Status>-1  '
Execute (@MySelect + @Filter )
GO