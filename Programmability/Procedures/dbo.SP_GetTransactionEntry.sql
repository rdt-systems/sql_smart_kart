SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SP_GetTransactionEntry]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000))
as

declare @MySelect nvarchar(4000)
declare @MyWhere nvarchar(4000)

declare @ItemSelect nvarchar(4000)
Set  @ItemSelect='Select Distinct ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1)  '

if @CustomerFilter<>''

	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select Distinct CustomerID , CustomerNo, Name as CustomerName
							  Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		SET @MyWhere=	' where TransactionEntryItem.Qty<>0 And  exists (Select 1 From #CustomerSelect where CustomerID=transactionentryitem.CustomerID ) '
	end 
 
ELSE
	SET @MyWhere=	' where TransactionEntryItem.Qty<>0  '


set @MySelect= 
   'SELECT     dbo.TransactionEntryItem.TransactionNo, 
	           dbo.TransactionEntryItem.TransactionType, 
			   dbo.TransactionEntryItem.TransactionID, 
			   dbo.TransactionEntryItem.StartSaleTime, 
	       	  
               dbo.TransactionEntryItem.ItemStoreID,
			   dbo.TransactionEntryItem.Qty, 
			   1 as Status,
               dbo.TransactionEntryItem.Total,
               dbo.TransactionEntryItem.AVGCost,
               dbo.TransactionEntryItem.RegCost as Cost,
               dbo.TransactionEntryItem.ExtCost,
               dbo.TransactionEntryItem.Total as ExtPrice,
	           dbo.TransactionEntryItem.Price as Price, 
	           dbo.TransactionEntryItem.QtyCase AS QtyCase,
		
	          (SELECT CASE WHEN dbo.TransactionEntryItem.TransactionType=0 THEN ''Sale'' 
			               WHEN  dbo.TransactionEntryItem.transactionType=3 THEN ''Return'' 
		       END) AS Type,
			   dbo.TransactionEntryItem.Total - dbo.TransactionEntryItem.TotalAfterDiscount as Discount,
		       --dbo.TransactionEntryItem.Discount as Discount,
               dbo.TransactionEntryItem.TotalAfterDiscount as TotalAfterDiscount,
			Customer.LastName + '' '' + Customer.FirstName AS CustomerName, Customer.CustomerNo, Stuff((SELECT    DISTINCT '','' +  Tender.TenderName
FROM            TenderEntry INNER JOIN
                         Tender ON TenderEntry.TenderID = Tender.TenderID
						 And TenderEntry.TransactionID = TransactionEntryItem.TransactionID
						 And TenderEntry.Status >0 FOR XML PATH(''''), TYPE ).value(''.'', ''varchar(max)''), 1, 1, '''') AS Payment
			 
FROM         dbo.TransactionEntryItem INNER JOIN
					#ItemSelect  ON dbo.TransactionEntryItem.ItemStoreID = #ItemSelect.ItemStoreID		LEFT OUTER JOIN
                      dbo.Customer ON TransactionEntryItem.CustomerID = Customer.CustomerID'
 			 
Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere +  @Filter )
print @ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere +  @Filter

drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO