SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SP_GetTransForHourlySales]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000))
as

declare @MySelect nvarchar(4000)
declare @ItemSelect nvarchar(4000)
declare @CustomerSelect nvarchar(4000)
declare @MyWhere nvarchar(4000)

SET @MyWhere =' WHERE (TransactionLivesView.TransactionType = 0 OR
                       TransactionLivesView.TransactionType = 3) AND (TransactionLivesView.StartSaleTime >=
                          dbo.GetCustomerDateStartBalance(dbo.TransactionLivesView.PID)) '

set @CustomerSelect=''

Set  @ItemSelect='Select Distinct ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1) '

if @CustomerFilter<>''

	begin 
		Set  @CustomerSelect='Select CustomerID 
							  Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		SET @MyWhere= @MyWhere+ 	' And exists (Select 1 From #ItemSelect where ItemStoreID=transactionEntryItem.ItemStoreID) And  exists (Select 1 From #CustomerSelect where CustomerID=transactionentryitem.CustomerID )  '
	end 
 
ELSE
    SET @MyWhere= @MyWhere+	' And exists (Select 1 From #ItemSelect where ItemStoreID=transactionEntry.ItemStoreID)'


set @MySelect= 'SELECT Type
					  ,DateT
					  ,Num
					  ,DueDate
					  ,OpenBalance
					  ,AmountPay
					  ,IDc
					  ,PID
					  ,Amount
					  ,Name
					  ,CustomerNo
					  ,TransactionLivesView.Status
					  ,Debit
					  ,Credit
					  ,TransactionType
					  ,StartSaleTime
					  ,TimeT
					  ,StoreID
					  ,StoreName
				FROM dbo.TransactionLivesView inner join 
                     dbo.TransactionEntry  WITH (NOLOCK)  On TransactionID=IDc And transactionEntry.Status>0
				'
--print (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter)

Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter)

drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO