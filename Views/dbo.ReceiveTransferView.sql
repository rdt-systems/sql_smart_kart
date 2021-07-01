SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO





CREATE View [dbo].[ReceiveTransferView]
AS

SELECT        ReceiveTransfer.ReceiveTransferID, ReceiveTransfer.ReceiveDate, ReceiveTransfer.TransferID, TransferItems.TransferNo, ISNULL(ReceiveTransfer.ReciveNo, 1) AS ReciveNo, TransferItems.TransferStatus, 
                         TransferItems.TransferDate, TransferItems.Note, UserTransfered.UserName AS TransferUser, UserReceived.UserName AS ReceiveUser, StoreReceived.StoreName AS StoreReceived, 
                         FromStore.StoreName AS FromStore, ToStore.StoreName AS ToStore, ReceiveTransfer.Status, TransferItems.FromStoreid, TransferItems.ToStoreID,ReceiveTransfer.StoreID
FROM            ReceiveTransfer INNER JOIN
                         TransferItems ON ReceiveTransfer.TransferID = TransferItems.TransferID INNER JOIN
                         Store AS StoreReceived ON ReceiveTransfer.StoreID = StoreReceived.StoreID INNER JOIN
                         Store AS FromStore ON TransferItems.FromStoreID = FromStore.StoreID INNER JOIN
                         Store AS ToStore ON TransferItems.ToStoreID = ToStore.StoreID LEFT OUTER JOIN
                         Users AS UserReceived ON ReceiveTransfer.UserCreate = UserReceived.UserId LEFT OUTER JOIN
                         Users AS UserTransfered ON TransferItems.UserCreated = UserTransfered.UserId
WHERE        (ReceiveTransfer.Status > 0) AND (TransferItems.Status > 0)
GO