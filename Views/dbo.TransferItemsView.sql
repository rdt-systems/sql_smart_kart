SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[TransferItemsView]
AS
SELECT        dbo.TransferItems.TransferID, dbo.TransferItems.TransferNo, dbo.TransferItems.FromStoreID, dbo.TransferItems.ToStoreID, dbo.TransferItems.TransferDate, dbo.TransferItems.Note, dbo.TransferItems.PersonID, 
                         dbo.TransferItems.Status, dbo.TransferItems.DateCreated, dbo.TransferItems.UserCreated, dbo.TransferItems.DateModified, dbo.TransferItems.UserModified, 
                         (CASE WHEN TransferStatus = 3 THEN 'CLOSE' WHEN TransferStatus = 2 THEN 'PARTIAL' ELSE 'OPEN' END) AS TransferStatusDec, ToStore.StoreName AS [To Store], FStore.StoreName AS [From Store], 
                         dbo.Users.UserName, ISNULL(TransferStatus,1) AS TransferStatus
FROM            dbo.TransferItems INNER JOIN
                         dbo.Store AS FStore ON dbo.TransferItems.FromStoreID = FStore.StoreID INNER JOIN
                         dbo.Store AS ToStore ON dbo.TransferItems.ToStoreID = ToStore.StoreID LEFT OUTER JOIN
                         dbo.Users ON dbo.TransferItems.UserCreated = dbo.Users.UserId
GO