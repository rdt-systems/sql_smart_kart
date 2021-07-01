SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[TransferOrderEntryView]
AS
SELECT     TOP 100 PERCENT   TransferOrderEntryID, TransferOrderID, ItemStoreNo, Qty, UOMQty, UOMType, UOMPrice, LinkNo, Note, SortOrder, Status, DateCreated, UserCreated, DateModified, UserModified
FROM            TransferOrderEntry
Order By dbo.TransferOrderEntry.SortOrder
GO