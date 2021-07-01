SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_OrderMatrixChields](@ID uniqueidentifier ,@StoreID uniqueidentifier)
AS 

select distinct itemmainParent.ItemID,itemmainParent.Name as ParentName,
itemmainParent.ModalNumber,itemmainchield.name,itemmainchield.matrix1 as color ,itemmainchield.matrix2 as size, PurchaseOrderEntry.SortOrder
from PurchaseOrderEntry 
--order by datecreated desc
join itemstore on itemstore.ItemStoreID=PurchaseOrderEntry.ItemNo
join itemmain on itemstore.itemno=itemmain.itemid
join itemmain as itemmainParent on itemmainParent.ItemID =itemmain.LinkNo
join itemmain as itemmainchield on itemmainchield.LinkNo =itemmainParent.ItemID
where @ID =PurchaseOrderEntry.PurchaseOrderno
Order By PurchaseOrderEntry.SortOrder
GO