SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_RepAdjusted] (
		@FromDate datetime,
		@ToDate datetime,
		@StoreID Uniqueidentifier = NULL)

AS

SELECT        ITMS.StoreName, ITMS.BarcodeNumber, ITMS.Name, ITMS.ModalNumber, ITMS.Cost, ITMS.Price, ITMS.Matrix1 AS Color, ITMS.Matrix2 AS Size, ITMS.OnHand AS CurrentOnHand, Adjust.TotalAdded
FROM            ItemMainAndStoreView AS ITMS INNER JOIN
                             (SELECT        ItemStoreNo, SUM(Qty) AS TotalAdded
                               FROM            AdjustInventory
                               WHERE        (DateCreated >= @FromDate) AND (DateCreated <= @ToDate + 1)
                               GROUP BY ItemStoreNo) AS Adjust ON ITMS.ItemStoreID = Adjust.ItemStoreNo 
WHERE        (ITMS.Status > 0)  AND (ITMS.StoreNo = @StoreID) OR
                         (ITMS.Status > 0) AND (@StoreID IS NULL)
GO