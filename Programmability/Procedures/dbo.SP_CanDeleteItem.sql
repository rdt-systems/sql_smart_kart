SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CanDeleteItem]
(@ItemStoreID uniqueidentifier)
As 

if 
 (select Count(1) from dbo.PurchaseOrderEntry
where ItemNo = @ItemStoreID and Status>-1 )+ 
(select Count(1) from dbo.ReceiveEntry
where ItemStoreNo = @ItemStoreID and Status>-1 )+ 
(select Count(1) from dbo.ReturnToVenderEntry
where ItemStoreNo = @ItemStoreID and Status>-1)+ 
(select Count(1) from dbo.TransactionEntry
where ItemStoreID = @ItemStoreID and Status>-1)+
(select Count(1) from dbo.TransferEntry
where ItemStoreNo =(SELECT TOP 1 ItemNo
					FROM ItemStore
					WHERE ItemStoreID=@ItemStoreID) And Status>-1)+
(select Count(1) from dbo.TransferOrderEntry
where ItemStoreNo =(SELECT TOP 1 ItemNo
					FROM ItemStore
					WHERE ItemStoreID=@ItemStoreID) And Status>-1)+


--Matrix Child
(select Count(1) from dbo.PurchaseOrderEntry
where Status>-1 And ItemNo IN (SELECT ItemStoreID From ItemMain join itemstore on ItemMain.ItemID=itemstore.ItemNo  Where ItemMain.LinkNo=
(SELECT TOP 1 ItemNo
																			FROM ItemStore
																			WHERE ItemStoreID=@ItemStoreID)
																			And StoreNo=(SELECT TOP 1 StoreNo
																			FROM ItemStore
																			WHERE ItemStoreID=@ItemStoreID)
																			And ItemMain.Status>-1
																			And itemstore.Status>-1
																			))+ 
(select Count(1) from dbo.ReceiveEntry
where ItemStoreNo IN (SELECT ItemStoreID From ItemMain join itemstore on ItemMain.ItemID=itemstore.ItemNo  Where ItemMain.LinkNo=
(SELECT TOP 1 ItemNo
																			FROM ItemStore
																			WHERE ItemStoreID=@ItemStoreID)
																			And StoreNo=(SELECT TOP 1 StoreNo
																			FROM ItemStore
																			WHERE ItemStoreID=@ItemStoreID)
																			And ItemMain.Status>-1
																			And itemstore.Status>-1))+
(select Count(1) from dbo.ReturnToVenderEntry
where ItemStoreNo IN (SELECT ItemStoreID From ItemMain join itemstore on ItemMain.ItemID=itemstore.ItemNo  Where ItemMain.LinkNo=
(SELECT TOP 1 ItemNo
																			FROM ItemStore
																			WHERE ItemStoreID=@ItemStoreID)
																			And StoreNo=(SELECT TOP 1 StoreNo
																			FROM ItemStore
																			WHERE ItemStoreID=@ItemStoreID)
																			And ItemMain.Status>-1
																			And itemstore.Status>-1))+ 
(select Count(1) from dbo.TransactionEntry
where ItemStoreID IN (SELECT ItemStoreID From ItemMain join itemstore on ItemMain.ItemID=itemstore.ItemNo  Where ItemMain.LinkNo=
(SELECT TOP 1 ItemNo
																			FROM ItemStore
																			WHERE ItemStoreID=@ItemStoreID)
																			And StoreNo=(SELECT TOP 1 StoreNo
																			FROM ItemStore
																			WHERE ItemStoreID=@ItemStoreID)
																			And ItemMain.Status>-1
																			And itemstore.Status>-1))+

(select Count(1) from dbo.TransferEntry
where ItemStoreNo IN (SELECT ItemID From ItemMain Where LinkNo=(SELECT TOP 1 ItemNo
																FROM ItemStore
																WHERE ItemStoreID=@ItemStoreID)) and Status>-1)+

(select Count(1) from dbo.TransferOrderEntry
where ItemStoreNo IN (SELECT ItemID From ItemMain Where LinkNo=(SELECT TOP 1 ItemNo
																FROM ItemStore
																WHERE ItemStoreID=@ItemStoreID)) and Status>-1)


=0
	select 1

else
	select 0
GO