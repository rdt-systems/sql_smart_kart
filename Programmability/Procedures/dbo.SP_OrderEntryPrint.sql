SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_OrderEntryPrint](@ID uniqueidentifier, @MySort nvarchar(100))
AS 

IF @MySort = 'Sort'
Set @MySort = 'PurchaseOrderEntryView.SortOrder'

IF @MySort = 'SortOrder'
Set @MySort = 'PurchaseOrderEntryView.SortOrder'

If @MySort = 'ItemName'
Set @MySort = 'Name'

Declare @MySelect nvarchar(4000)
Set @MySelect = '
SELECT DISTINCT 
                         PurchaseOrderEntryView.ItemName AS Name, PurchaseOrderEntryView.UPC AS BarcodeNumber, PurchaseOrderEntryView.ModalNumber, 
                         PurchaseOrderEntryView.UOMQty, SysUOMTypeView.SystemValueName AS UOM, PurchaseOrderEntryView.UOMPrice, 
                         PurchaseOrderEntryView.ExtPrice AS TotalPrice, PurchaseOrderEntryView.PurchaseOrderNo, PurchaseOrderEntryView.Note, PurchaseOrderEntryView.Status, 
                         PurchaseOrderEntryView.SortOrder, PurchaseOrderEntryView.CaseQty, PurchaseOrderEntryView.Brand, PurchaseOrderEntryView.Size, 
                         ISNULL(PurchaseOrderEntryView.[Supplier Item Code], '''') AS SupllyCode, (CASE WHEN IsNull([Supplier Item Code], '''') 
                         = '''' THEN ParentCode ELSE [Supplier Item Code] END) AS ParentSupplerCode, PurchaseOrderEntryView.ParentName, PurchaseOrderEntryView.Matrix1, 
                         PurchaseOrderEntryView.Matrix2,
						 PurchaseOrderEntryView.LinkNo,
						 PurchaseOrderEntryView.NetCost
FROM            PurchaseOrderEntryView INNER JOIN
                         PurchaseOrders ON PurchaseOrderEntryView.PurchaseOrderNo = PurchaseOrders.PurchaseOrderId INNER JOIN
                         SysUOMTypeView ON PurchaseOrderEntryView.UOMType = SysUOMTypeView.SystemValueNo
WHERE        (PurchaseOrderEntryView.PurchaseOrderNo =''' +CONVERT(varchar(100), @ID) + ''') AND (PurchaseOrderEntryView.Status > 0) ORDER BY '

Print (@MySelect + @MySort)
Exec (@MySelect + @MySort)
GO