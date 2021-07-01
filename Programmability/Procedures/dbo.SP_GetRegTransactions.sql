SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetRegTransactions]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.TransactionView.*
                FROM       dbo.TransactionView
	        WHERE     (Status > - 1)'
Execute (@MySelect + @Filter )
GO