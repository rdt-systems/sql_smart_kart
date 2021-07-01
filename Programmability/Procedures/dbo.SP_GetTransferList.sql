SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransferList](@StartDate datetime,
@EndDate datetime)
AS SELECT     dbo.TransferItems.TransferID, dbo.TransferItems.TransferNo, dbo.Store.StoreName as FromStore, Store_1.StoreName AS [ToStore], 
                      dbo.TransferItems.TransferDate
FROM         dbo.TransferItems INNER JOIN
                      dbo.Store ON dbo.TransferItems.FromStoreID = dbo.Store.StoreID INNER JOIN
                      dbo.Store Store_1 ON dbo.TransferItems.ToStoreID = Store_1.StoreID
WHERE     (dbo.TransferItems.TransferDate >= @StartDate) AND (dbo.TransferItems.TransferDate < @EndDate)
	   AND (dbo.TransferItems.Status >0)
GO