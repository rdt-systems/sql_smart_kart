SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[MakeCostValuation]
@ItemStoreID uniqueidentifier,
@TransactionEntryID uniqueidentifier,
@Qty decimal,
@UserID uniqueidentifier

AS

Declare @QtyFromRec decimal --Holds Qty sold from the receive
Declare @RecEntryID uniqueidentifier --Holds ReceiveEntryID
Declare @RecQty decimal --Holds All Qty in the Receive
Declare @CostValuation int --Holds Cost Valuation settings for this item
Declare @AdjustID uniqueidentifier -- Holds AdjustInventoryID to connect to receive
/* Get Settings*/
SELECT @CostValuation=ProfitCalculation FROM ItemStore WHERE ItemStoreID=@ItemStoreID
/* If settings is AVG - calc average cost for this item and insert into TransactionEntry AVGCost
    Then RETURN - EXIT*/
IF @CostValuation = 0 --AVG 
BEGIN  
   UPDATE TransactionEntry SET AVGCost = (SELECT Sum(Qty * Cost)/ Sum(Qty) FROM ReceiveEntry WHERE ItemStoreNo=@ItemStoreID)
   WHERE  TransactionEntryID = @TransactionEntryID 
   RETURN
END
/* If settings is FIFO(LIFO Is the same beside ORDER BY is DESC) Then:
   Open  Cursor and get all ReceiveEntry rows that 
   has Qty that has not been sold or returned to vendor or adjusted  */
IF @CostValuation = 1 --FIFO 
BEGIN 
	DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT isnull(dbo.ReceiveEntry.Qty,0) - isnull(RecToSale.RecQty,0)
	       -isnull(RecToAdjust.RecQty,0) - isnull(RecToReturn.RecQty,0) as Qty,dbo.ReceiveEntry.ReceiveEntryID
	FROM dbo.ReceiveEntry
		LEFT OUTER JOIN
		(SELECT SUM(Qty) As RecQty ,ReceiveEntryID
		FROM dbo.ReceiveToSale
		GROUP BY ReceiveEntryID)
		As RecToSale
	        ON dbo.ReceiveEntry.ReceiveEntryID = RecToSale.ReceiveEntryID 
	
		LEFT OUTER JOIN
		(SELECT SUM(Qty*-1) As RecQty ,ReceiveEntryID
		FROM dbo.ReceiveToAdjust
	        Where Qty<0
		GROUP BY ReceiveEntryID)
		As RecToAdjust
		ON dbo.ReceiveEntry.ReceiveEntryID = RecToAdjust.ReceiveEntryID 
	
		LEFT OUTER JOIN
		(SELECT SUM(Qty) As RecQty ,ReceiveEntryID
		FROM dbo.ReceiveToReturnEntry
		GROUP BY ReceiveEntryID)
		As RecToReturn
		ON dbo.ReceiveEntry.ReceiveEntryID = RecToReturn.ReceiveEntryID 
	
	WHERE isnull(dbo.ReceiveEntry.Qty,0) - isnull(RecToSale.RecQty,0)
	       -isnull(RecToAdjust.RecQty,0) - isnull(RecToReturn.RecQty,0) > 0
	ORDER BY dbo.ReceiveEntry.DateCreated ASC
	
	OPEN c1
	/* Get First row*/
	FETCH NEXT FROM c1
	INTO @RecQty,@RecEntryID
	
	/* loop untill no more receives opened(not sold/return/adjust) left*/
	WHILE  @@FETCH_STATUS = 0
	BEGIN
                 
		
                /* @QtyFromRec = Qty opened for this receive minus Qty in transaction*/
	        Set  @QtyFromRec = @RecQty-@Qty
		 /*  It can be 1 of 3 options(example):
                   1) 5-5 =0 ,  2) 8-5= 3  ,3)5-8 = -3
		   IF option 1 OR 2 Then it means that there is more or equal  qty 
		   opened in the receive - SO it just inserts the transaction Qty
		   linked to this receive  and EXIT*/
		IF @QtyFromRec>=0
		BEGIN
			INSERT INTO dbo.ReceiveToSale(TransactionEntryID,ReceiveEntryID,Qty,Status,DateCreated,UserCreated,DateModified,UserModified)
			VALUES(@TransactionEntryID,@RecEntryID,@Qty,1,dbo.GetLocalDATE(),@UserID,null,null)
			RETURN
		END
		/* IF option 3 is true:
                   Insert  @RecQty = Qty that left in this receive and fetch next and keep looping untill no more
		   Qty is left in transaction  */
		INSERT INTO dbo.ReceiveToSale(TransactionEntryID,ReceiveEntryID,Qty,Status,DateCreated,UserCreated,DateModified,UserModified)
	        VALUES(@TransactionEntryID,@RecEntryID,@RecQty,1,dbo.GetLocalDATE(),@UserID,null,null)    
		/* take off receive qty - in the example 8=8-5= 3 ( the same as  @QtyFromRec*-1 )  */
                Set @Qty = @Qty - @RecQty
		FETCH NEXT FROM c1
		INTO @RecQty,@RecEntryID
	END
	CLOSE c1
	DEALLOCATE c1
	
	/*IF @QtyFromRec<0
	BEGIN
		 we cant do this :UPDATE TransactionEntry SET Cost=.... WHERE TransactionEntryID = @TransactionEntryID 
                because it may be partial so we do need another table afor
                items that are not in receive and not in any where 
                that the qty and cost for them will take from default cost
		set @Qty= @QtyFromRec
		DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
		SELECT  isnull(dbo.AdjustInventory.Qty,0) -isnull(RecToAdjust.RecQty,0) AS Qty,dbo.AdjustInventory.AdjustInventoryId
		FROM 
			dbo.AdjustInventory
			LEFT OUTER JOIN
			(SELECT SUM(Qty) As RecQty ,AdjustId
			FROM dbo.ReceiveToAdjust
			Where Qty>0
			GROUP BY AdjustId)
			As RecToAdjust
			ON dbo.AdjustInventory.AdjustInventoryId = RecToAdjust.AdjustId 
	
		WHERE isnull(dbo.AdjustInventory.Qty,0) -isnull(RecToAdjust.RecQty,0) > 0
		ORDER BY dbo.AdjustInventory.DateCreated ASC
		
		OPEN c1
		
		FETCH NEXT FROM c1
		INTO @RecQty,@AdjustID
		
		WHILE  @@FETCH_STATUS = 0
		BEGIN
		        Set  @QtyFromRec = @RecQty-@Qty
			IF @QtyFromRec>=0
			BEGIN
				INSERT INTO dbo.ReceiveToAdjust
				VALUES(@AdjustID,@RecEntryID,@Qty,1,dbo.GetLocalDATE(),@UserID,null,null)
				BREAK
			END
			INSERT INTO dbo.ReceiveToAdjust
			VALUES(@AdjustID,@RecEntryID,@Qty,1,dbo.GetLocalDATE(),@UserID,null,null)   
			Set @Qty = @Qty - @QtyFromRec
			
			FETCH NEXT FROM c1
			INTO @RecQty,@RecEntryID
		END
		CLOSE c1
		DEALLOCATE c1
	END*/
END
IF @CostValuation = 2 --LIFO  - exactly the same but ORDER BY is DESC
BEGIN 
	DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT isnull(dbo.ReceiveEntry.Qty,0) - isnull(RecToSale.RecQty,0)
	       -isnull(RecToAdjust.RecQty,0) - isnull(RecToReturn.RecQty,0) as Qty,dbo.ReceiveEntry.ReceiveEntryID
	FROM dbo.ReceiveEntry
		LEFT OUTER JOIN
		(SELECT SUM(Qty) As RecQty ,ReceiveEntryID
		FROM dbo.ReceiveToSale
		GROUP BY ReceiveEntryID)
		As RecToSale
	        ON dbo.ReceiveEntry.ReceiveEntryID = RecToSale.ReceiveEntryID 
	
		LEFT OUTER JOIN
		(SELECT SUM(Qty*-1) As RecQty ,ReceiveEntryID
		FROM dbo.ReceiveToAdjust
	        Where Qty<0
		GROUP BY ReceiveEntryID)
		As RecToAdjust
		ON dbo.ReceiveEntry.ReceiveEntryID = RecToAdjust.ReceiveEntryID 
	
		LEFT OUTER JOIN
		(SELECT SUM(Qty) As RecQty ,ReceiveEntryID
		FROM dbo.ReceiveToReturnEntry
		GROUP BY ReceiveEntryID)
		As RecToReturn
		ON dbo.ReceiveEntry.ReceiveEntryID = RecToReturn.ReceiveEntryID 
	
	WHERE isnull(dbo.ReceiveEntry.Qty,0) - isnull(RecToSale.RecQty,0)
	       -isnull(RecToAdjust.RecQty,0) - isnull(RecToReturn.RecQty,0) > 0
	ORDER BY dbo.ReceiveEntry.DateCreated DESC
	
	OPEN c1
	
	FETCH NEXT FROM c1
	INTO @RecQty,@RecEntryID
	
	
	WHILE  @@FETCH_STATUS = 0
	BEGIN
	        Set  @QtyFromRec = @RecQty-@Qty
		IF @QtyFromRec>=0
		BEGIN
			INSERT INTO dbo.ReceiveToSale(TransactionEntryID,ReceiveEntryID,Qty,Status,DateCreated,UserCreated,DateModified,UserModified)
			VALUES(@TransactionEntryID,@RecEntryID,@Qty,1,dbo.GetLocalDATE(),@UserID,null,null)
			BREAK
		END
		INSERT INTO dbo.ReceiveToSale(TransactionEntryID,ReceiveEntryID,Qty,Status,DateCreated,UserCreated,DateModified,UserModified)
	        VALUES(@TransactionEntryID,@RecEntryID,@QtyFromRec,1,dbo.GetLocalDATE(),@UserID,null,null)    
		Set @Qty = @Qty - @QtyFromRec
		FETCH NEXT FROM c1
		INTO @RecQty,@RecEntryID
	END
	CLOSE c1
	DEALLOCATE c1
	
	IF @QtyFromRec<0
	BEGIN
		set @Qty= @QtyFromRec
		DECLARE c1 CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
		SELECT  isnull(dbo.AdjustInventory.Qty,0) -isnull(RecToAdjust.RecQty,0) AS Qty,dbo.AdjustInventory.AdjustInventoryId
		FROM 
			dbo.AdjustInventory
			LEFT OUTER JOIN
			(SELECT SUM(Qty) As RecQty ,AdjustId
			FROM dbo.ReceiveToAdjust
			Where Qty>0
			GROUP BY AdjustId)
			As RecToAdjust
			ON dbo.AdjustInventory.AdjustInventoryId = RecToAdjust.AdjustId 
	
		WHERE isnull(dbo.AdjustInventory.Qty,0) -isnull(RecToAdjust.RecQty,0) > 0
		ORDER BY dbo.AdjustInventory.DateCreated DESC
		
		OPEN c1
		
		FETCH NEXT FROM c1
		INTO @RecQty,@AdjustID
		
		WHILE  @@FETCH_STATUS = 0
		BEGIN
		        Set  @QtyFromRec = @RecQty-@Qty
			IF @QtyFromRec>=0
			BEGIN
				INSERT INTO dbo.ReceiveToAdjust(AdjustID,ReceiveEntryID,Qty,Status,DateCreated,UserCreated,DateModified,UserModified)
				VALUES(@AdjustID,@RecEntryID,@Qty,1,dbo.GetLocalDATE(),@UserID,null,null)
				BREAK
			END
			INSERT INTO dbo.ReceiveToAdjust(AdjustID,ReceiveEntryID,Qty,Status,DateCreated,UserCreated,DateModified,UserModified)
			VALUES(@AdjustID,@RecEntryID,@Qty,1,dbo.GetLocalDATE(),@UserID,null,null)   
			Set @Qty = @Qty - @QtyFromRec
			FETCH NEXT FROM c1
			INTO @RecQty,@RecEntryID
		END
		CLOSE c1
		DEALLOCATE c1
	END

END
GO