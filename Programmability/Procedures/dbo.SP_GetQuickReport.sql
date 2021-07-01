SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetQuickReport]
(@ItemStoreID uniqueidentifier,
 @StartDate DateTime,
 @EndDate DateTime,
 @ItemID uniqueidentifier =null,
  @Stores Guid_list_tbltype READONLY
)

as 

 IF not EXISTS ( Select 1 from @Stores) 
 begin 
SELECT 

	TransactionEntry.TransactionID as ID,
	(CASE WHEN TransactionType=0 THEN 'Sale'
		  ELSE 'Return'
	 End) as Type,
	StartSaleTime as Date,
	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
	qty*-1 as Qty, Users.UserName As Usr

FROM

	TransactionEntry
	INNER JOIN
	  [Transaction] on [Transaction].TransactionID=TransactionEntry.TransactionID LEFT OUTER Join Users On [Transaction].UserCreated = Users.UserID

WHERE
	[Transaction].Status>0 AND
	TransactionEntry.Status>0 AND
	ItemStoreID=@ItemStoreID AND
	StartSaleTime>=@StartDate AND
	StartSaleTime<@EndDate
	and TransactionEntry.TransactionEntryType <>2 
    and TransactionEntry.TransactionEntryType <>11 

UNION ALL
SELECT        TransactionEntry.TransactionID AS ID, 'Return' AS Type, DamageItem.Date, 'Pc' AS UOM, DamageItem.Qty, Users.UserName As Usr
FROM            DamageItem INNER JOIN
                         TransactionEntry ON DamageItem.TransactionEntryID = TransactionEntry.TransactionEntryID LEFT OUTER Join Users On TransactionEntry.UserCreated = Users.UserID
WHERE        (DamageItem.Status > 0) AND 
             (DamageItem.DamageStatus = 1)AND
             (TransactionEntry.Status>0) AND
			 DamageItem.ItemStoreID=@ItemStoreID AND
	         DamageItem.Date>=@StartDate AND
	         DamageItem.Date<@EndDate


UNION ALL

SELECT        [Transaction].TransactionID As ID, 'Layaway' AS Type,
	StartSaleTime as Date, 'Pc' AS UOM, Layaway.Qty*-1 As Qty, Users.UserName As Usr
FROM            [Transaction] INNER JOIN
                         Layaway ON [Transaction].TransactionID = Layaway.TransactionID LEFT OUTER Join Users On [Transaction].UserCreated = Users.UserID
WHERE        (Layaway.LayawayStatus = 1) AND 
             ([Transaction].Status > 0) AND 
			 (Layaway.Status > 0)AND
             ItemStoreID=@ItemStoreID AND
	         StartSaleTime>=@StartDate AND
	         StartSaleTime<@EndDate 


UNION ALL

SELECT 
	ReceiveEntry.ReceiveNo as ID,
	'Receive' as Type,
	ReceiveOrderDate as Date,
	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
	Qty as Qty, Users.UserName As Usr FROM	ReceiveEntry	INNER JOIN
	  ReceiveOrderview on ReceiveOrderview.ReceiveID=ReceiveEntry.ReceiveNo LEFT OUTER Join Users On ReceiveOrderview.UserCreated = Users.UserID
WHERE	
    ReceiveOrderview.Status>0 AND
	ReceiveEntry.Status>0 AND
	ItemStoreNo=@ItemStoreID AND
	ReceiveOrderDate>=@StartDate AND
	ReceiveOrderDate<@EndDate 

UNION ALL

SELECT 

	ReturnToVender.ReturnToVenderID as ID,
	'Return To Vender' as Type,
	ReturnToVenderDate as Date,
	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
	Qty*-1 as Qty, Users.UserName As Usr

FROM

	ReturnToVenderEntry
	INNER JOIN
	  ReturnToVender on ReturnToVender.ReturnToVenderID=ReturnToVenderEntry.ReturnToVenderID  LEFT OUTER Join Users On ReturnToVenderEntry.UserCreated = Users.UserID

WHERE

	ReturnToVender.Status>0 AND
	ReturnToVenderEntry.Status>0 AND
	ItemStoreNo=@ItemStoreID AND
	ReturnToVenderDate>=@StartDate AND
	ReturnToVenderDate<@EndDate 

UNION ALL

SELECT 

	AdjustInventoryId as ID,
	(CASE WHEN AdjustType=4 THEN 'Start Qty'
		  ELSE 'Adjust Inventory'
	 END) as Type,
	AdjustInventory.DateCreated as Date,
	('Pc')as UOM,
	Qty as Qty, Users.UserName As Usr

FROM

	dbo.AdjustInventory LEFT OUTER Join Users On AdjustInventory.UserCreated = Users.UserID
	
WHERE
	AdjustInventory.Status>0 AND
	AdjustInventory.ItemStoreNo=@ItemStoreID AND
	AdjustInventory.DateCreated>=@StartDate AND
	AdjustInventory.DateCreated<@EndDate 

UNION ALL

SELECT 

	TransferEntry.TransferID as ID,
	'Transfer' as Type,
	TransferDate as Date,
	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
	Qty*-1 as Qty, Users.UserName As Usr

FROM

	dbo.TransferEntry
	INNER JOIN
	  dbo.TransferItems on TransferItems.TransferID=TransferEntry.TransferID    LEFT OUTER Join Users On TransferEntry.UserCreated = Users.UserID

WHERE
	TransferItems.Status>0 AND
	TransferEntry.Status>0 AND TransferEntry.Status<25 AND
	TransferDate>=@StartDate AND
	TransferDate<@EndDate AND
	    (SELECT ItemStoreID
	    FROM ItemStore
	    WHERE TransferEntry.ItemStoreNo = ItemStoreID --ItemNo 
		--And StoreNo= (SELECT FromStoreID  FROM   TransferItems  WHERE  TransferID=TransferEntry.TransferID)
															   ) = @ItemStoreID


UNION ALL

--SELECT 

--	TransferEntry.TransferID as ID,
--	'Transfer' as Type,
--	TransferDate as Date,
--	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
--	Qty as Qty

--FROM

--	dbo.TransferEntry
--	INNER JOIN
--	  dbo.TransferItems on TransferItems.TransferID=TransferEntry.TransferID

--WHERE
--	TransferItems.Status>0 AND
--	TransferEntry.Status>0 AND
--	TransferDate>=@StartDate AND
--	TransferDate<@EndDate AND
--	    (SELECT ItemStoreID
--	    FROM ItemStore
--	    WHERE TransferEntry.ItemStoreNo = ItemNo And StoreNo= (SELECT ToStoreID 
--															   FROM   TransferItems
--															   WHERE  TransferID=TransferEntry.TransferID)) = @ItemStoreID


SELECT 

	ReceiveTransfer.TransferID  as ID,
	'Transfer' as Type,
	ReceiveDate as Date,
	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
	Qty as Qty, Users.UserName As Usr

FROM

	dbo.ReceiveTransfer
	INNER JOIN
	  dbo.ReceiveTransferEntry on ReceiveTransfer.ReceiveTransferID=ReceiveTransferEntry.ReceiveTransferID LEFT OUTER Join Users On ReceiveTransferEntry.UserCreate = Users.UserID

WHERE
	ReceiveTransfer.Status>0 AND
	ReceiveTransferEntry.Status>0 AND
	ReceiveDate>=@StartDate AND
	ReceiveDate<@EndDate AND
	    (SELECT ItemStoreID
	    FROM ItemStore
	    WHERE ReceiveTransferEntry.ItemStoreID  = ItemStoreID --ItemNo 
		--And StoreNo= (SELECT FromStoreID  FROM   TransferItems  WHERE  TransferID=TransferEntry.TransferID)
															   ) = @ItemStoreID
end 


else 

begin 

SELECT 

	TransactionEntry.TransactionID as ID,
	(CASE WHEN TransactionType=0 THEN 'Sale'
		  ELSE 'Return'
	 End) as Type,
	StartSaleTime as Date,
	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
	qty*-1 as Qty, Users.UserName As Usr
	,[Store].StoreName
FROM

	TransactionEntry
	INNER JOIN
	  [Transaction] on [Transaction].TransactionID=TransactionEntry.TransactionID 
	  INNER JOIN
	  [ItemStore] on [ItemStore].itemStoreid=TransactionEntry.ItemStoreID 
	    INNER JOIN
	  [Store] on [ItemStore].Storeno=[Store].StoreID 
	  LEFT OUTER Join Users On [Transaction].UserCreated = Users.UserID


WHERE
	[Transaction].Status>0 AND
	TransactionEntry.Status>0 AND
	[ItemStore].Itemno=@ItemID AND
	StartSaleTime>=@StartDate AND
	StartSaleTime<@EndDate
	and TransactionEntry.TransactionEntryType <>2 
	AND TransactionEntry.TransactionEntryType <>11
	AND  [ItemStore].Storeno in (select n from  @Stores)

UNION ALL
SELECT        TransactionEntry.TransactionID AS ID, 'Return' AS Type, DamageItem.Date, 'Pc' AS UOM, DamageItem.Qty, Users.UserName As Usr
,[Store].StoreName
FROM            DamageItem INNER JOIN
                         TransactionEntry ON DamageItem.TransactionEntryID = TransactionEntry.TransactionEntryID 

						  INNER JOIN
	  [ItemStore] on [ItemStore].itemStoreid=TransactionEntry.ItemStoreID 
	    INNER JOIN
	  [Store] on [ItemStore].Storeno=[Store].StoreID 

						 LEFT OUTER Join Users On TransactionEntry.UserCreated = Users.UserID
WHERE        (DamageItem.Status > 0) AND 
             (DamageItem.DamageStatus = 1)AND
             (TransactionEntry.Status>0) AND
			 [ItemStore].ItemNo=@ItemID AND
	         DamageItem.Date>=@StartDate AND
	         DamageItem.Date<@EndDate
			 	AND  [ItemStore].Storeno in (select n from  @Stores)

UNION ALL

SELECT        [Transaction].TransactionID As ID, 'Layaway' AS Type,
	StartSaleTime as Date, 'Pc' AS UOM, Layaway.Qty*-1 As Qty, Users.UserName As Usr
	,[Store].StoreName
FROM            [Transaction] INNER JOIN
                         Layaway ON [Transaction].TransactionID = Layaway.TransactionID 
						  INNER JOIN
	  [ItemStore] on [ItemStore].itemStoreid=Layaway.ItemStoreID 
	    INNER JOIN
	  [Store] on [ItemStore].Storeno=[Store].StoreID 
						 LEFT OUTER Join Users On [Transaction].UserCreated = Users.UserID
WHERE        (Layaway.LayawayStatus = 1) AND 
             ([Transaction].Status > 0) AND 
			 (Layaway.Status > 0)AND
              [ItemStore].ItemNo=@ItemID AND
	         StartSaleTime>=@StartDate AND
	         StartSaleTime<@EndDate 
			 	AND  [ItemStore].Storeno in (select n from  @Stores)

UNION ALL

SELECT 
	ReceiveEntry.ReceiveNo as ID,
	'Receive' as Type,
	ReceiveOrderDate as Date,
	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
	Qty as Qty, Users.UserName As Usr 
	,[Store].StoreName
	FROM	ReceiveEntry	INNER JOIN
	  ReceiveOrderview on ReceiveOrderview.ReceiveID=ReceiveEntry.ReceiveNo 
	   INNER JOIN
	  [ItemStore] on [ItemStore].itemStoreid=ReceiveEntry.ItemStoreno
	    INNER JOIN
	  [Store] on [ItemStore].Storeno=[Store].StoreID 
	  LEFT OUTER Join Users On ReceiveOrderview.UserCreated = Users.UserID
WHERE	
    ReceiveOrderview.Status>0 AND
	ReceiveEntry.Status>0 AND
    [ItemStore].ItemNo=@ItemID AND
	ReceiveOrderDate>=@StartDate AND
	ReceiveOrderDate<@EndDate 
	AND  [ItemStore].Storeno in (select n from  @Stores)

UNION ALL

SELECT 

	ReturnToVender.ReturnToVenderID as ID,
	'Return To Vender' as Type,
	ReturnToVenderDate as Date,
	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
	Qty*-1 as Qty, Users.UserName As Usr
	,[Store].StoreName

FROM

	ReturnToVenderEntry
	INNER JOIN
	  ReturnToVender on ReturnToVender.ReturnToVenderID=ReturnToVenderEntry.ReturnToVenderID  
	   INNER JOIN
	  [ItemStore] on [ItemStore].itemStoreid=ReturnToVenderEntry.ItemStoreno
	    INNER JOIN
	  [Store] on [ItemStore].Storeno=[Store].StoreID 
	  LEFT OUTER Join Users On ReturnToVenderEntry.UserCreated = Users.UserID

WHERE

	ReturnToVender.Status>0 AND
	ReturnToVenderEntry.Status>0 AND
    [ItemStore].ItemNo=@ItemID AND
	ReturnToVenderDate>=@StartDate AND
	ReturnToVenderDate<@EndDate 
     AND  [ItemStore].Storeno in (select n from  @Stores)
UNION ALL

SELECT 

	AdjustInventoryId as ID,
	(CASE WHEN AdjustType=4 THEN 'Start Qty'
		  ELSE 'Adjust Inventory'
	 END) as Type,
	AdjustInventory.DateCreated as Date,
	('Pc')as UOM,
	Qty as Qty, Users.UserName As Usr
	,[Store].StoreName

FROM

	dbo.AdjustInventory 
	 INNER JOIN
	  [ItemStore] on [ItemStore].itemStoreid=AdjustInventory.ItemStoreno
	    INNER JOIN
	  [Store] on [ItemStore].Storeno=[Store].StoreID 
	
	LEFT OUTER Join Users On AdjustInventory.UserCreated = Users.UserID
	
WHERE
	AdjustInventory.Status>0 AND
    [ItemStore].ItemNo=@ItemID AND
	AdjustInventory.DateCreated>=@StartDate AND
	AdjustInventory.DateCreated<@EndDate 
 AND  [ItemStore].StoreNo in (select n from  @Stores)

UNION ALL

SELECT 

	TransferEntry.TransferID as ID,
	'Transfer' as Type,
	TransferDate as Date,
	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
	Qty*-1 as Qty, Users.UserName As Usr
	,[Store].StoreName

FROM

	dbo.TransferEntry
	INNER JOIN
	  dbo.TransferItems on TransferItems.TransferID=TransferEntry.TransferID   
	   INNER JOIN
	  [ItemStore] on [ItemStore].itemStoreid=TransferEntry.ItemStoreno
	    INNER JOIN
	  [Store] on [ItemStore].Storeno=[Store].StoreID 
	  
	   LEFT OUTER Join Users On TransferEntry.UserCreated = Users.UserID

WHERE
	TransferItems.Status>0 AND
	TransferEntry.Status>0 AND TransferEntry.Status<25 AND
	TransferDate>=@StartDate AND
	TransferDate<@EndDate 
	and  [ItemStore].ItemNo=@ItemID
	 AND  [ItemStore].StoreNo in (select n from  @Stores)


UNION ALL

--SELECT 

--	TransferEntry.TransferID as ID,
--	'Transfer' as Type,
--	TransferDate as Date,
--	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
--	Qty as Qty

--FROM

--	dbo.TransferEntry
--	INNER JOIN
--	  dbo.TransferItems on TransferItems.TransferID=TransferEntry.TransferID

--WHERE
--	TransferItems.Status>0 AND
--	TransferEntry.Status>0 AND
--	TransferDate>=@StartDate AND
--	TransferDate<@EndDate AND
--	    (SELECT ItemStoreID
--	    FROM ItemStore
--	    WHERE TransferEntry.ItemStoreNo = ItemNo And StoreNo= (SELECT ToStoreID 
--															   FROM   TransferItems
--															   WHERE  TransferID=TransferEntry.TransferID)) = @ItemStoreID


SELECT 

	ReceiveTransfer.TransferID  as ID,
	'Transfer' as Type,
	ReceiveDate as Date,
	(CASE WHEN UOMType =0 THEN 'Pc' WHEN UOMType = 2 THEN 'Case' END)as UOM,
	Qty as Qty, Users.UserName As Usr
	,[Store].StoreName

FROM

	dbo.ReceiveTransfer
	INNER JOIN
	  dbo.ReceiveTransferEntry on ReceiveTransfer.ReceiveTransferID=ReceiveTransferEntry.ReceiveTransferID 
	    INNER JOIN
	  [ItemStore] on [ItemStore].itemStoreid=ReceiveTransferEntry.ItemStoreID
	    INNER JOIN
	  [Store] on [ItemStore].Storeno=[Store].StoreID 
	  LEFT OUTER Join Users On ReceiveTransferEntry.UserCreate = Users.UserID

WHERE
	ReceiveTransfer.Status>0 AND
	ReceiveTransferEntry.Status>0 AND
	ReceiveDate>=@StartDate AND
	ReceiveDate<@EndDate 
	AND  [ItemStore].ItemNo=@ItemID
	 AND  [ItemStore].StoreNo in (select n from  @Stores)

UNION ALL

Select
    RequestTransfer.RequestTransferID,
    'Request' As type,
    RequestTransfer.RequestDate As Date,
    (Case
        When RTE.UOMType = 0
        Then 'Pc'
        When RTE.UOMType = 2
        Then 'Case'
    End) As UOM,
    -(Case
        When IsNull(Transfer.Qty, 0) > RTE.Qty
        Then 0
        Else RTE.Qty - IsNull(Transfer.Qty, 0)
    End) As Qty,
    Users.UserName,''As StoreName
From
    ItemStore As Its Inner Join
    RequestTransferEntry As RTE On Its.ItemNo = RTE.ItemId Inner Join
    RequestTransfer On RequestTransfer.RequestTransferID = RTE.RequestTransferID
            And Its.StoreNo = RequestTransfer.FromStoreID Left Join
    (Select
         TransferEntry.RequestTransferEntryID,
         TransferEntry.Qty
     From
         TransferItems Inner Join
         TransferEntry On TransferEntry.TransferID = TransferItems.TransferID
     Where
         TransferEntry.RequestTransferEntryID Is Not Null And
         TransferItems.Status > 0 And
         TransferEntry.Status > 0) Transfer On Transfer.RequestTransferEntryID = RTE.RequestTransferEntryID Left Join
    Users On Users.UserId = RequestTransfer.UserCreated
Where
    RTE.Status > 0 And
    RequestTransfer.Status > 0 And
    RequestTransfer.RequestDate >= @StartDate And
    RequestTransfer.RequestDate < @EndDate And
    Its.ItemNo = @ItemID And
	[Its].StoreNo in (select n from  @Stores) AND  
    (Case
        When IsNull(Transfer.Qty, 0) > RTE.Qty
        Then 0
        Else RTE.Qty - IsNull(Transfer.Qty, 0)
    End) <> 0


end
GO