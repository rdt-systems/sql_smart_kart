SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetInvoices]
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT DISTINCT  dbo.InvoicesView.*
		FROM dbo.InvoicesView
		WHERE  1=1 '
Execute (@MySelect + @Filter )
GO