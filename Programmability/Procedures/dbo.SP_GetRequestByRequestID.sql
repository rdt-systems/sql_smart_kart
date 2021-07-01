SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetRequestByRequestID]  
(@Filter nvarchar(4000))  
  
as  
declare @MySelect nvarchar(4000)  
Set @MySelect = 'SELECT        RequestTransfer.RequestTransferID,   
RequestTransferEntryView.RequestTransferEntryID,  
RequestTransferEntryView.Name,   
RequestTransferEntryView.BarcodeNumber,   
RequestTransferEntryView.ModalNumber,   
RequestTransferEntryView.UOMQty as RequestUOMQty,  
RequestTransferEntryView.TransferQty as PreviousTranferQty,  
RequestTransferEntryView.RequestDeficit AS QTY,   
RequestTransferEntryView.ReciveUOMQty,  
       SysUOMTypeView.SystemValueName AS UOM,   
                         RequestTransferEntryView.RequestTransferEntryID AS ID,   
       ISNULL(RequestTransferEntryView.CaseQty, 1) AS CaseQty,   
                         RequestTransferEntryView.RequestNo AS PONO,   
       RequestTransferEntryView.ItemStoreID,   
       ISNULL(RequestTransferEntryView.ItemID, '''') AS ItemCode,  
       RequestTransferEntryView.UOMType,  
       RequestTransferEntryView.BinLocation,  
       RequestTransferEntryView.FromItemStoreID,  
       RequestTransferEntryView.ItemID  
FROM            RequestTransferEntryView INNER JOIN  
                         RequestTransfer ON RequestTransfer.RequestTransferID = RequestTransferEntryView.RequestTransferID INNER JOIN  
                         SysUOMTypeView ON RequestTransferEntryView.UOMType = SysUOMTypeView.SystemValueNo  
WHERE        (RequestTransferEntryView.RequestDeficit > 0) AND (RequestTransferEntryView.Status > 0)  
  
'  
  
print(@MySelect + @Filter +' ORDER BY RequestTransferEntryView.BinLocation,RequestTransferEntryView.SortOrder')  
Execute (@MySelect + @Filter +' ORDER BY RequestTransferEntryView.BinLocation,RequestTransferEntryView.SortOrder')
GO