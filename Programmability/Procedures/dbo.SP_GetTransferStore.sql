SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransferStore]
(@StartDate datetime,
@EndDate datetime,
@StoreID uniqueidentifier=null)
AS 
SELECT     dbo.TransferItems.TransferID, dbo.TransferItems.TransferNo, dbo.Store.StoreName as ToStore, FromStore.StoreName as StoreName,
              dbo.TransferItems.TransferDate
FROM          dbo.TransferItems LEFT Outer JOIN
              dbo.Store ON dbo.TransferItems.ToStoreID = dbo.Store.StoreID LEFT Outer JOIN
              dbo.Store as FromStore ON dbo.TransferItems.FromStoreID = FromStore.StoreID
WHERE    (dbo.TransferItems.TransferDate >= @StartDate) AND (dbo.TransferItems.TransferDate < @EndDate) 
	      AND   (dbo.TransferItems.Status >0)  AND (dbo.TransferItems.FromStoreID=@StoreID OR @StoreID is null)
GO