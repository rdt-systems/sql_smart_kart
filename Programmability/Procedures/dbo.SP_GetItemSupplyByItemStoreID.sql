SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemSupplyByItemStoreID]
(@ID uniqueidentifier)
As 


select * from dbo.ItemSupplyView
where ItemStoreNo=@ID and Status>0
union 

select * from dbo.ItemSupplyView where itemStoreNo in(Select ItemStoreID from ItemStore where ItemNo in (select ItemNo from ItemStore where ItemNo in(select itemID from Itemmain where LinkNo =(
SELECT        ItemMain.Itemid
FROM            ItemMain INNER JOIN
                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo
where ItemStoreID=@ID))) and StoreNo = (select StoreNo from ItemStore where ItemStoreID=@ID)) and Status>0
GO