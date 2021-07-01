SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ReceiveTransferEntryView]
AS
SELECT        ReceiveTransferEntry.ReceiveTranferEntryID, ReceiveTransferEntry.ItemStoreID, ReceiveTransferEntry.TransferEntryID, ReceiveTransferEntry.Qty, ReceiveTransferEntry.UOMQty, ReceiveTransferEntry.Status, 
                         TransferEntry.Qty AS TransferedQty, TransferEntry.UOMQty AS TransferedUOMQty, ISNULL(ReceiveTransfer.ReciveNo, 1) AS ReceiveNo, TransferItems.TransferID, TransferItems.TransferNo, TransferEntry.Note, 
                         ItemMainAndStoreView.ItemID, ItemMainAndStoreView.Name, ItemMainAndStoreView.ModalNumber, ItemMainAndStoreView.BarcodeNumber, ItemMainAndStoreView.StyleNo,  
                         ItemMainAndStoreView.Price as UOMPrice, ItemMainAndStoreView.[Pc Cost], ItemMainAndStoreView.[Cs Cost], ItemMainAndStoreView.Department, ItemMainAndStoreView.CaseQty, Users.UserName AS UserReceived, 
                         ReceiveTransferEntry.ReceiveTransferID, (case ReceiveTransferEntry.Cost when 0 then ItemMainAndStoreView.Cost when null then ItemMainAndStoreView.Cost else ReceiveTransferEntry.Cost end) as Cost,ReceiveTransferEntry.UOMType as UOMType,  SysUOMTypeView.SystemValueName as  UOMTypeName
FROM            ReceiveTransferEntry INNER JOIN
                         TransferEntry ON ReceiveTransferEntry.TransferEntryID = TransferEntry.TransferEntryID INNER JOIN
                         TransferItems ON TransferEntry.TransferID = TransferItems.TransferID INNER JOIN
                         ReceiveTransfer ON ReceiveTransferEntry.ReceiveTransferID = ReceiveTransfer.ReceiveTransferID INNER JOIN
                         ItemMainAndStoreView ON ReceiveTransferEntry.ItemStoreID = ItemMainAndStoreView.ItemStoreID INNER JOIN
                         Users ON ReceiveTransferEntry.UserCreate = Users.UserId 
						 inner join SysUOMTypeView  on SysUOMTypeView.SystemValueNo=ReceiveTransferEntry.UOMType
GO