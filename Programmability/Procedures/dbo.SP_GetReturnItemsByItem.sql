SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReturnItemsByItem]
(@Filter nvarchar(4000),
@ItemFilter nvarchar(4000),
@CustomerFilter nvarchar(4000))

as
declare @MyWhere nvarchar(4000)

declare @ItemSelect nvarchar(4000)
Set @ItemSelect='Select Distinct ItemStoreID
Into #ItemSelect
From ItemsRepFilter
Where (1=1) '

if @CustomerFilter<>''

BEGIN
	declare @CustomerSelect nvarchar(4000)
	Set @CustomerSelect=' Select Distinct CustomerID
	Into #CustomerSelect
	From CustomerRepFilter
	Where (1=1) '
	SET @MyWhere= ' where dbo.TransactionEntryView.Status>0 AND ((TransactionEntryView.TransactionEntryType = 2 AND TransactionEntryView.Qty <> 0)OR QTY<0) And exists (Select 1 From #ItemSelect where ItemStoreID=TransactionEntryView.ItemStoreID) And exists (Select 1 From #CustomerSelect where CustomerID=TransactionEntryView.CustomerID ) '
END
ELSE
	SET @MyWhere= ' where dbo.TransactionEntryView.Status>0 AND ((TransactionEntryView.TransactionEntryType = 2 AND TransactionEntryView.Qty <> 0)OR QTY<0) And exists (Select 1 From #ItemSelect where ItemStoreID=TransactionEntryView.ItemStoreID) '


declare @MySelect nvarchar(4000)
set @MySelect=' SELECT        ISNULL(TransactionEntryView.Name, ''[MANUAL ITEM]'') AS Name, TransactionEntryView.ModalNumber, TransactionEntryView.ItemCode, ISNULL(TransactionEntryView.Qty, 0) AS Qty, 
                         ISNULL(TransactionEntryView.Total, 0) AS Amount, Supplier.Name AS SuppName, TransactionEntryView.Note AS ReturnReason, [Transaction].TransactionID, [Transaction].StoreID, 
                         MAX(TransactionEntryView.Price) AS Price, MAX(TransactionEntryView.OnHand) AS OnHand, TheSale.SaleTransNo, TheSale.SaleTransID
FROM            TransactionEntryView INNER JOIN
                         [Transaction] ON TransactionEntryView.TransactionID = [Transaction].TransactionID LEFT OUTER JOIN
                             (SELECT        TransReturen.ReturenID, TransReturen.SaleTransEntryID, TransReturen.ReturenTransID, TransReturen.DateCreated, Num.SaleTransNo, Num.SaleTransID, Num.TransactionEntryID
                               FROM            TransReturen INNER JOIN
                                                             (SELECT        T1.TransactionNo AS SaleTransNo, T1.TransactionID AS SaleTransID, TransactionEntry.TransactionEntryID
                                                               FROM            [Transaction] AS T1 INNER JOIN
                                                                                         TransactionEntry ON T1.TransactionID = TransactionEntry.TransactionID) AS Num ON TransReturen.ReturenTransID = Num.TransactionEntryID) AS TheSale ON 
                         TransactionEntryView.TransactionEntryID = TheSale.SaleTransEntryID LEFT OUTER JOIN
                         SystemValues ON TransactionEntryView.ReturnReason = SystemValues.SystemValueNo AND SystemValues.SystemTableNo = 29 LEFT OUTER JOIN
                         ItemSupply ON TransactionEntryView.ItemStoreID = ItemSupply.ItemStoreNo AND ItemSupply.Status > 0 AND ItemSupply.IsMainSupplier = 1 LEFT OUTER JOIN
                         Supplier ON ItemSupply.SupplierNo = Supplier.SupplierID AND ItemSupply.Status > 0 AND ItemSupply.IsMainSupplier = 1
'
Declare @MyGroupBy nvarchar(4000)/*full variable added by SB 11/24/10*/
set @MyGroupBy=' GROUP BY 
TransactionEntryView.Name, 
TransactionEntryView.ModalNumber, 
TransactionEntryView.ItemCode, 
TransactionEntryView.Qty, 
TransactionEntryView.Total, 
TransactionEntryView.Note, 
SystemValues.SystemValueName, 
Supplier.Name, 
TransactionEntryView.ItemStoreID, 
[Transaction].TransactionID, 
[Transaction].StoreID, 
TheSale.SaleTransNo, 
TheSale.SaleTransID '


print (@ItemSelect + @ItemFilter + @MySelect + @MyWhere + @Filter + @MyGroupBy )


Execute (@ItemSelect + @ItemFilter + @CustomerSelect + @CustomerFilter + @MySelect + @MyWhere + @Filter + @MyGroupBy )
GO