SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetPrintLabels]
(@StoreID uniqueidentifier,
 @UserID  uniqueidentifier = null)
AS

IF @UserID = '00000000-0000-0000-0000-000000000000' SET @StoreID = NULL

IF @UserID IS Null BEGIN
   SELECT    PrintLabelsID,PrintLabels.ItemStoreID,Tag,PrintLabels.Status,PrintLabels.DateCreated,PrintLabels.UserCreated,PrintLabels.DateModified,PrintLabels.UserModified, 
		 dbo.ItemMainAndStoreView.BarcodeNumber, dbo.ItemMainAndStoreView.ModalNumber, dbo.ItemMainAndStoreView.Name,ISNULL(Qty,1) as Qty, dbo.ItemMainAndStoreView.OnHand,dbo.PrintLabels.StoreID
         FROM         dbo.PrintLabels INNER JOIN  dbo.ItemMainAndStoreView ON dbo.PrintLabels.ItemStoreID = dbo.ItemMainAndStoreView.ItemStoreID
         WHERE  (dbo.PrintLabels.Status >0) And (dbo.PrintLabels.StoreID=@StoreID OR @StoreID IS NULL)
		 Order By DateCreated
END
ELSE BEGIN
	SELECT    PrintLabelsID,PrintLabels.ItemStoreID,Tag,PrintLabels.Status,PrintLabels.DateCreated,PrintLabels.UserCreated,PrintLabels.DateModified,PrintLabels.UserModified, 
		 dbo.ItemMainAndStoreView.BarcodeNumber, dbo.ItemMainAndStoreView.ModalNumber, dbo.ItemMainAndStoreView.Name,ISNULL(Qty,1) as Qty, dbo.ItemMainAndStoreView.OnHand,dbo.PrintLabels.StoreID
         FROM         dbo.PrintLabels INNER JOIN
                      dbo.ItemMainAndStoreView ON dbo.PrintLabels.ItemStoreID = dbo.ItemMainAndStoreView.ItemStoreID
                WHERE  (dbo.PrintLabels.Status  > 0) And (dbo.PrintLabels.StoreID=@StoreID OR @StoreID IS NULL) AND (PrintLabels.UserCreated =@UserID)
					 Order By DateCreated
 END
GO