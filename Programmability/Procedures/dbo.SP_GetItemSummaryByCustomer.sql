SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_GetItemSummaryByCustomer]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @CustomerFilter nvarchar(4000))

AS 

DECLARE @MySelect nvarchar(4000)
DECLARE @MyGroup nvarchar(4000)
DECLARE @MyWhere nvarchar(4000)

declare @ItemSelect nvarchar(4000)
Set  @ItemSelect='Select ItemStoreID 
				  Into #ItemSelect 
                  From ItemsRepFilter 
                  Where (1=1) '

if @CustomerFilter<>''

	begin 
		declare @CustomerSelect nvarchar(4000)
		Set  @CustomerSelect=' Select CustomerID 
							  Into #CustomerSelect 
							  From CustomerRepFilter 
							  Where (1=1) '
		SET @MyWhere=	' where (1=1) And  exists (Select 1 From #CustomerSelect where CustomerID=transactionentryitem.CustomerID ) '
	end 
 
ELSE
	SET @MyWhere=	' where (1=1)  '

--*********************************************

set @MySelect='
    SELECT     TransactionEntryItem.ItemStoreID, TransactionEntryItem.Name, TransactionEntryItem.ModalNumber, TransactionEntryItem.BarcodeNumber, 
                      TransactionEntryItem.ItemTypeName, TransactionEntryItem.Department, TransactionEntryItem.DepartmentID, TransactionEntryItem.Supplier, 
                      TransactionEntryItem.SupplierCode AS ItemCodeSupplier, TransactionEntryItem.Brand, SUM(TransactionEntryItem.QTY) AS Qty, SUM(TransactionEntryItem.QtyCase) 
                      AS QtyCase, SUM(TransactionEntryItem.ExtCost) AS ExtCost, SUM(TransactionEntryItem.Total) AS ExtPrice, 
                      (CASE WHEN SUM(TransactionEntryItem.TotalAfterDiscount) = 0 THEN 0 ELSE SUM(TransactionEntryItem.Profit) / SUM(TransactionEntryItem.TotalAfterDiscount) END) 
                      AS MarginPrice, (CASE WHEN SUM(TransactionEntryItem.ExtCost) <> 0 THEN SUM(TransactionEntryItem.Profit) / SUM(TransactionEntryItem.ExtCost) ELSE 0 END) 
                      AS MarkupPrice, SUM(TransactionEntryItem.Profit) AS Profit, SUM(TransactionEntryItem.Discount) AS Discount, SUM(TransactionEntryItem.TotalAfterDiscount) 
                      AS TotalAfterDiscount, TransactionEntryItem.StoreName, TransactionEntryItem.StoreID, TransactionEntryItem.ItemID, MAX(TransactionEntryItem.Price) AS Price, 
                      MAX(TransactionEntryItem.OnHand) AS OnHand, Customer.CustomerNo, Customer.LastName + '' '' + Customer.FirstName AS [CustomerName]
FROM         dbo.TransactionEntryItem INNER JOIN #ItemSelect ON TransactionEntryItem.ItemStoreID = #ItemSelect.ItemStoreID   LEFT OUTER JOIN
                      dbo.Customer ON TransactionEntryItem.CustomerID = Customer.CustomerID' 

set @MyGroup = '

	GROUP BY TransactionEntryItem.ItemStoreID, TransactionEntryItem.Name, TransactionEntryItem.ModalNumber, TransactionEntryItem.BarcodeNumber, 
                      TransactionEntryItem.ItemTypeName, TransactionEntryItem.Department, TransactionEntryItem.DepartmentID, TransactionEntryItem.Supplier, 
                      TransactionEntryItem.SupplierCode, TransactionEntryItem.Brand, TransactionEntryItem.StoreName, TransactionEntryItem.StoreID, TransactionEntryItem.ItemID, 
                      Customer.CustomerNo, Customer.LastName + '' '' + Customer.FirstName '



--Print   @ItemSelect + @ItemFilter +@MySelect + @MyWhere + @Filter +@MyGroup
Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect  + @MyWhere + @Filter +@MyGroup )


--drop table #ItemSelect
if @CustomerFilter<>''
drop table #CustomerSelect
GO