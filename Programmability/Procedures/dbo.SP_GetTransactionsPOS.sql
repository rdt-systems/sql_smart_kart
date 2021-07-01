SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetTransactionsPOS]
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
--WAITFOR DELAY '00:00:10'
set @MySelect= 'SELECT   * FROM dbo.TransactionPOSView  as TransactionWithPaidView
		WHERE  Status> -1'
print (@MySelect + @Filter )
Execute (@MySelect + @Filter )
GO