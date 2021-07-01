SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetItemsOnGlobalChange]
(@UserID uniqueidentifier)
AS
SELECT        ItemStoreIDs.ItemStoreID, ITMS.Name, ITMS.BarcodeNumber, ITMS.ModalNumber, ITMS.[Cs Cost], ITMS.[Pc Cost], ITMS.Price, ITMS.[SP Price], ITMS.[SP From], ITMS.[SP To], ITMS.IsTaxable, ITMS.IsDiscount, 
                         ITMS.IsFoodStampable, ITMS.IsWIC, ITMS.Department, ITMS.SupplierName, ITMS.Brand, ITMS.Groups, ITMS.Matrix1 AS Color, CASE WHEN ISNULL(ITMS.Size, '') 
                         = '' THEN ITMS.Matrix2 ELSE ITMS.Size END AS Size
FROM            ItemStoreIDs INNER JOIN
                         ItemMainAndStoreView AS ITMS ON ItemStoreIDs.ItemStoreID = ITMS.ItemStoreID
WHERE        (ItemStoreIDs.UserID = @UserID)
GO