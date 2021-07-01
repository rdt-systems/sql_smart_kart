SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransactionDiscount]
(@Filter nvarchar(4000),
@CustomerFilter nvarchar(4000))
AS

Declare @BaseFilter nvarchar(4000)
--set @BaseFilter='(dbo.TransactionEntryView.TransactionEntryType = 4) AND 
--		         (dbo.TransactionEntryView.UOMPrice <> 0) AND 
--			     (dbo.TransactionEntryView.Status > 0) AND 
--		         (dbo.TransactionView.TransactionType = 0) AND 
--		         (dbo.TransactionView.Status > 0) '
		         
set @BaseFilter='(dbo.TransactionEntryView.TransactionEntryType = 4) AND 
			     (dbo.TransactionEntryView.Status > 0) AND 
		         (dbo.TransactionView.TransactionType = 0) AND 
		         (dbo.TransactionView.Status > 0) '		       

declare @MyWhere nvarchar(4000)
if @CustomerFilter<>''
	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select CustomerID 
							   Into #CustomerSelect 
							   From CustomerRepFilter 
							   Where (1=1) '
		SET @MyWhere=  ' AND exists (Select 1 From #CustomerSelect where CustomerID=dbo.TransactionView.CustomerID) '
	end 
 else
     SET @MyWhere= ''

--*********************************************

declare @Select nvarchar(4000)
set @Select='
	SELECT     dbo.TransactionView.TransactionID, 
			   dbo.TransactionView.TransactionNo, 
		       dbo.TransactionView.StartSaleTime, 
		       dbo.TransactionView.Debit +isnull(TotalReturn,0) + isnull(TotalReturnTax,0) AS SaleTotal,     
       dbo.TransactionView.Debit-dbo.TransactionView.Tax  +isnull(TotalReturn,0) as SaleTotalWithoutTax,             
	       dbo.CustomerView.CustomerNo,     
		       CASE WHEN dbo.CustomerView.LastName IS NOT NULL OR dbo.CustomerView.FirstName IS NOT NULL THEN                 ISNULL(dbo.CustomerView.LastName,'''') + '', '' + ISNULL(dbo.CustomerView.FirstName,'''') ELSE NULL END as CustomerName,         
			      (dbo.TransactionView.Debit + dbo.TransactionEntryView.UOMPrice+isnull(TotalReturn,0) + isnull(TotalReturnTax,0)
				 + isnull(disRetern,0)) AS TotalBeforeDiscount,     
			      dbo.TransactionEntryView.UOMPrice + isnull(disRetern,0)  AS Discount,        
		      ---- TotalQtyTransaction.Total as TotalBeforeDiscount,
		       TotalQtyTransaction.TotalQty as Qty,
			   dbo.TransactionView.StoreID,
			   dbo.TransactionView.Credit As Paid

	FROM       dbo.TransactionEntryView 
		       INNER JOIN
                   dbo.TransactionView ON dbo.TransactionEntryView.TransactionID = dbo.TransactionView.TransactionID 
		       LEFT OUTER JOIN
                   (select TransactionEntryView.TransactionID,sum(TransactionEntryView.Qty) as TotalQty,sum(TransactionEntryView.Total) as Total   ,SUM(ter.Total) AS TotalReturn , min(trr.Tax) TotalReturnTax          ,sum(((TransactionEntryView.Total -TransactionEntryView.TotalAfterDiscount) /TransactionEntryView.Qty)*ter.Qty) as disRetern
		     from dbo.TransactionEntryView    

		LEFT OUTER JOIN       TransReturen ON TransReturen.ReturenTransID = TransactionEntryView.TransactionEntryID LEFT OUTER JOIN
                        TransactionEntry AS ter ON ter.TransactionEntryID = TransReturen.SaleTransEntryID AND ter.Status > 0
					LEFT OUTER JOIN [Transaction] trr on trr.TransactionID =ter.TransactionID and trr.Status>0


			    where TransactionEntryView.Status>0 And TransactionEntryView.TransactionEntryType = 0     
			   group by TransactionEntryView.TransactionID)as TotalQtyTransaction ON TotalQtyTransaction.TransactionID = dbo.TransactionView.TransactionID 
			   LEFT OUTER JOIN
                   dbo.CustomerView ON dbo.TransactionView.CustomerID = dbo.CustomerView.CustomerID  AND dbo.CustomerView.Status > 0
				   

	WHERE       '

	insert into sqlStatmentLog(sqlString) values(@select  + @BaseFilter + @MyWhere + @Filter )	
print  @select  + @BaseFilter + @MyWhere + @Filter 		   
exec ( @CustomerSelect + @CustomerFilter + @select  + @BaseFilter + @MyWhere + @Filter  )


if @CustomerFilter<>''
drop table #CustomerSelect
GO