SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  VIEW [dbo].[FullItemNamesWithAlias]
AS

SELECT  cast ( ItemStoreID as varchar(50))ItemStoreID, ItemType,FullName,BarcodeNumber,ModalNumber, 
        StoreNo, MainStatus,  StoreStatus from FullItemNames
UNION
SELECT ItemStoreID, ItemType,FullName,ItemAliasView.BarcodeNumber,ModalNumber, 
        StoreNo, MainStatus,  StoreStatus
FROM FullItemNames
INNER JOIN dbo.ItemAliasView
ON FullItemNames.ItemID=ItemAliasView.itemno
GO