SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_Fix_AvgCost]

AS

DECLARE @Date datetime
DECLARE @ItemStoreID Uniqueidentifier
DECLARE @Qty decimal
DECLARE @NetCost money
DECLARE @CaseQty decimal
Declare @Final money

declare @AVGCost money
Declare @OnHand decimal
Declare @MyItemID Uniqueidentifier

DECLARE B CURSOR FOR Select R.ReceiveOrderDate, E.ItemStoreNo, E.Qty, E.CaseQty, E.NetCost  from ReceiveEntry E INNER JOIN ReceiveOrder R ON E.ReceiveNo = R.ReceiveID INNER JOIN Bill B ON R.BillID = B.BillID
Where E.Status > 0 and R.Status > 0 and B.Status > 0
Order By E.ItemStoreNo, R.ReceiveOrderDate

OPEN B

FETCH NEXT FROM B INTO @Date, @ItemStoreID, @Qty, @CaseQty, @NetCost
WHILE @@FETCH_STATUS = 0 BEGIN

SELECT TOP(1) @MyItemID = ItemNo From ItemStore Where ItemStoreID = @ItemStoreID
SELECT  @OnHand =  SUM(IsNull(Qty,0)) From  dbo.FnGetItemOnhand(@Date) AS S Where ItemID = @MyItemID


BEGIN TRY
  IF @OnHand <=0 
    SET @AVgCost = @Final
  ELSE
    SET @AVGCost =(SELECT ((@OnHand*ISnull(AVGCost,Cost))+(@Qty*@Final))/ (CASE WHEN @OnHand +@Qty<>0 THEN(@OnHand +@Qty)WHEN @Qty<>0 THEN @QTY ELSE 1 END) 
	FROM ItemStore 
	where ItemStoreID=@ItemStoreID)

IF (@AVGCost > (@Final*3)) OR (@AVGCost < -(@Final*3))
  set @AVgCost = @Final
END TRY
BEGIN CATCH
  SET @AVgCost = @Final
END CATCH

Update ItemStore Set AVGCost = @AVGCost, DateModified = dbo.GetLocalDATE() Where ItemNo = @MyItemID

Update TransactionEntry Set AvgCost = @AVGCost
From TransactionEntry EE INNER JOIN [Transaction] T ON EE.TransactionID = T.TransactionID
Where EE.ItemStoreID = @ItemStoreID and T.StartSaleTime >= @Date

FETCH NEXT FROM B INTO @Date, @ItemStoreID, @Qty, @CaseQty, @NetCost

END
CLOSE B
DEALLOCATE B
GO