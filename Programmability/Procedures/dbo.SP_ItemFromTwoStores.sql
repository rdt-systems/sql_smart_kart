SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemFromTwoStores]
(@FromStoreID uniqueidentifier,
 @ToStoreID uniqueidentifier)

As

Select ItemID,[Name],BarcodeNumber,ModalNumber,LinkNo,CaseQty,PrefOrderBy,ItemType
From ItemMain INNER JOIN
     ItemStore ON ItemStore.ItemNo=ItemMain.ItemID And ItemStore.Status>-1 And ItemStore.StoreNo=@FromStoreID
where Exists (Select * From ItemStore 
               Where StoreNo=@ToStoreID And Status>-1 And ItemStore.ItemNo=ItemMain.ItemID) 
      AND ItemMain.Status>-1 And ItemType<>2
GO