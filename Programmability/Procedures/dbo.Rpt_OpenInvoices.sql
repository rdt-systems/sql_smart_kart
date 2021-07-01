SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_OpenInvoices] 
(@Filter nvarchar(max),
@CustomerFilter nvarchar(max))

AS

if @CustomerFilter<>''
	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select CustomerID 
							   Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		declare @MyWhere nvarchar(4000)
		SET @MyWhere=	' and exists (Select 1 From #CustomerSelect where CustomerID=InvoicesView.PID ) '
	end 

declare @Sel1 nvarchar(4000)
set @Sel1 = 'SELECT * 
FROM InvoicesView
WHERE OpenBalance>0 and Status>0   and credit <debit  and (Select Status from customer where customerId=InvoicesView.PID)>0 '

execute (@CustomerSelect+@CustomerFilter+@Sel1 + @Filter+@MyWhere)
GO