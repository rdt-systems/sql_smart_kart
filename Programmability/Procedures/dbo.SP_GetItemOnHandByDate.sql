SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetItemOnHandByDate] @ItemID UNIQUEIDENTIFIER,
@UpToDate DATETIME

AS

	--Declare @StartQty int
	DECLARE @TotalQty INT
	--SET @StartQty = (SELECT isnull(dbo.ItemStore.StartQty,0) FROM dbo.ItemStore WHERE dbo.ItemStore.ItemStoreID=@ItemID)

	IF (SELECT
				ISNULL(ItemMain.ItemType, 0) AS ItemType
			FROM ItemStore
			INNER JOIN ItemMain
				ON ItemStore.ItemNo = ItemMain.ItemID
			WHERE (ItemStore.ItemStoreID = @ItemID))
		IN (3, 5, 7, 9)
		SET @TotalQty = 0
	ELSE

		SELECT
			@TotalQty = ISNULL((SELECT
					SUM(QTY)
				FROM ReceiveEntry
				INNER JOIN ReceiveOrderView
					ON ReceiveEntry.ReceiveNo = ReceiveOrderView.ReceiveID
				WHERE ItemStoreNo = @ItemID
				AND ReceiveEntry.Status > 0
				AND ReceiveOrderView.ReceiveOrderDate < @UpToDate
				AND ReceiveOrderView.Status > 0)
			, 0) 
			- ISNULL((SELECT
					SUM(QTY)
				FROM TransactionEntry
				INNER JOIN [Transaction]
					ON TransactionEntry.TransactionID = [Transaction].TransactionID
				WHERE ItemStoreID = @ItemID
				AND TransactionEntry.Status > 0
				AND [Transaction].StartSaleTime < @UpToDate
				AND [Transaction].Status > 0
				AND TransactionEntryType <> 2
				AND TransactionEntryType <> 11)
			, 0) 
			- ISNULL((SELECT
					SUM(Layaway.Qty) AS Qty
				FROM [Transaction]
				INNER JOIN Layaway
					ON [Transaction].TransactionID = Layaway.TransactionID
				WHERE (Layaway.LayawayStatus = 1)
				AND ([Transaction].Status > 0)
				AND (Layaway.Status > 0)
				AND ItemStoreID = @ItemID
				AND StartSaleTime < @UpToDate)
			, 0) 
			+ ISNULL((SELECT
					SUM(QTY)
				FROM DamageItem
				WHERE ItemStoreID = @ItemID
				AND DamageItem.[Date] < @UpToDate
				AND DamageItem.Status > 0
				AND DamageStatus = 1)
			, 0) 
			+ ISNULL((SELECT
					SUM(QTY)
				FROM AdjustInventory
				WHERE ItemStoreNo = @ItemID
				AND DateCreated < @UpToDate
				AND Status > 0)
			, 0) 
			- ISNULL((SELECT
					SUM(ISNULL(QTY, 0))
				FROM ReturnToVenderEntry
				INNER JOIN ReturnToVender
					ON ReturnToVenderEntry.ReturnToVenderID = ReturnToVender.ReturnToVenderID
				WHERE ItemStoreNo = @ItemID
				AND ReturnToVenderEntry.Status > 0
				AND ReturnToVender.ReturnToVenderDate < @UpToDate
				AND ReturnToVender.Status > 0)
			, 0) 
			- ISNULL((SELECT
					SUM(CASE
						WHEN ISNULL(Transfer.QTY, 0) > RTE.QTY THEN 0
						ELSE RTE.QTY - ISNULL(Transfer.QTY, 0)
					END) AS TransferQty
				FROM ItemStore AS Its
				INNER JOIN RequestTransferEntry AS RTE
					ON Its.ItemNo = RTE.ItemID
				INNER JOIN RequestTransfer
					ON RequestTransfer.RequestTransferID = RTE.RequestTransferID
					AND Its.StoreNo = RequestTransfer.FromStoreID
				LEFT JOIN (SELECT
						TransferEntry.RequestTransferEntryID
					   ,TransferEntry.QTY
					FROM TransferItems
					INNER JOIN TransferEntry
						ON TransferEntry.TransferID = TransferItems.TransferID
					WHERE TransferEntry.RequestTransferEntryID IS NOT NULL
					AND TransferItems.Status > 0
					AND TransferEntry.Status > 0) Transfer
					ON Transfer.RequestTransferEntryID = RTE.RequestTransferEntryID
				WHERE RTE.Status > 0
				AND RequestTransfer.Status > 0
				AND Its.ItemStoreID = @ItemID
				AND RequestTransfer.RequestDate < @UpToDate)
			, 0) 
			+ ISNULL((SELECT
					SUM(QTY)
				FROM ReceiveTransferEntry
				WHERE ItemStoreID = @ItemID
				AND DateCreate <= @UpToDate
				AND Status > 0)
			, 0)

			--(select sum(isnull(Qty,0))
			-- from TransferEntry inner join
			--      TransferItems on TransferItems.TransferID=TransferEntry.TransferID
			--where (SELECT ItemStoreID
			--	   FROM ItemMainAndStoreView
			--	   WHERE  ItemID = TransferEntry.ItemStoreNo And StoreNo= (SELECT ToStoreID 
			--															  FROM   TransferItems
			--															  WHERE  TransferID=TransferEntry.TransferID)) = ItemStore.ItemStoreID and TransferEntry.Status>0 and TransferItems.TransferDate <= @UpToDate and TransferItems.Status>0) 
			--,0)
			- ISNULL((SELECT
					SUM(ISNULL(QTY, 0))
				FROM TransferEntry
				INNER JOIN TransferItems
					ON TransferItems.TransferID = TransferEntry.TransferID
				WHERE ItemStoreNo = @ItemID
				AND TransferEntry.Status > 0
				AND TransferItems.TransferDate <= @UpToDate
				AND TransferItems.Status > 0
				AND TransferEntry.Status < 25)
			, 0)

	SELECT
		@TotalQty
GO