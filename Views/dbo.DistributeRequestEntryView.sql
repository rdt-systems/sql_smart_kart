SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[DistributeRequestEntryView]
AS
SELECT        dbo.DistributeRequestEntry.DistributeRequestEntryID, dbo.DistributeRequestEntry.DistributeRequestID, dbo.DistributeRequestEntry.ItemID, 
                         dbo.DistributeRequestEntry.Qty, dbo.DistributeRequestEntry.DateCreated, dbo.DistributeRequestEntry.UserCreated, dbo.DistributeRequestEntry.DateModified, 
                         dbo.DistributeRequestEntry.UserModified, ISNULL(dbo.DistributeRequestEntry.Status, 1) AS Status, dbo.ItemMain.Name, dbo.ItemMain.ModalNumber, 
                         dbo.ItemMain.BarcodeNumber
FROM            dbo.DistributeRequestEntry INNER JOIN
                         dbo.ItemMain ON dbo.DistributeRequestEntry.ItemID = dbo.ItemMain.ItemID
WHERE        (ISNULL(dbo.DistributeRequestEntry.Status, 1) > 0)
GO