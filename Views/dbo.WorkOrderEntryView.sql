SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE    VIEW [dbo].[WorkOrderEntryView]
AS
SELECT     dbo.WorkOrderEntry.*, dbo.ItemMainView.Name, dbo.ItemMainView.ModalNumber, dbo.ItemMainView.BarcodeNumber,
		isnull(WorkOrderEntry.Qty,1)*dbo.WorkOrderEntry.Price AS Total,
		 isnull(WorkOrderEntry.Qty,1)*dbo.WorkOrderEntry.Price/
		(case when isnull (WorkOrderEntry.UOMQty,WorkOrderEntry.Qty)=0 then 1 else isnull (WorkOrderEntry.UOMQty,WorkOrderEntry.Qty) end) as UOMPrice
FROM         dbo.WorkOrderEntry INNER JOIN
                      dbo.ItemStoreView ON dbo.WorkOrderEntry.ItemStoreID = dbo.ItemStoreView.ItemStoreID INNER JOIN
                      dbo.ItemMainView ON dbo.ItemStoreView.ItemNo = dbo.ItemMainView.ItemID
GO