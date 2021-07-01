SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[RPT_TotalReceive]
(@Filter nvarchar(4000),
 @ItemFilter nvarchar(4000),
 @SupplierName nvarchar(250) = '',
 @SeasonID nvarchar(250) = '')

as
declare @MySelect nvarchar(4000)
declare @MyWhere nvarchar(4000)


declare @ItemSelect nvarchar(4000)
declare @MyGroup nvarchar(4000)
declare @MyGroup1 nvarchar(4000)



Set  @ItemSelect='Select Distinct ItemStoreID 
				  Into #ItemSelect 
                  From dbo.ItemsRepFilter 
                  Where (1=1) '


				  
SET @MySelect='SELECT  SupplierName,BarcodeNumber, ParentName As Name,Department, Groups, Matrix1, Matrix2, SUM(ExtPrice) AS ExtPrice, SUM(Qty) AS Qty,
Min(ReceveHistoryView.OnHand) AS OnHand, IsNull(Sales.SaleQty,0) As SaleQty, MIN(ISNULL(ReceveHistoryView.OnOrder,0)) AS OnOrder,sum(profit) as profit  '+
			   'FROM  dbo.ReceveHistoryView INNSER JOIN #ItemSelect ON ReceveHistoryView.ItemStoreNo = #ItemSelect.ItemStoreID LEFT OUTER JOIN   (SELECT        SUM(QTY) AS SaleQty,sum(profit) as profit, ItemID FROM TransactionEntryItem where 1=1'

SET @MyGroup1 ='GROUP BY ItemID) AS Sales ON ReceveHistoryView.ItemID = Sales.ItemID' 

SET @MyWhere=	' where (1=1) '

if @SupplierName <> ''
Begin
	set @MyWhere = @MyWhere + ' and ReceveHistoryView.SupplierName = ' + '''' + @SupplierName + ''''
End

if @SeasonID <> ''
Begin
	set @MyWhere = @MyWhere + ' and ReceveHistoryView.SeasonID = ' + '''' + @SeasonID + ''''
End

SET @MyGroup ='GROUP BY BarcodeNumber, Matrix1, Matrix2,  Department, Groups, ParentName, SupplierName, Sales.SaleQty '

PRINT(@ItemSelect + @ItemFilter + @MySelect + @Filter + @MyGroup1 + @MyWhere + @Filter + @MyGroup)
Execute (@ItemSelect + @ItemFilter + @MySelect + @Filter + @MyGroup1 + @MyWhere + @Filter + @MyGroup)

drop table #ItemSelect
GO