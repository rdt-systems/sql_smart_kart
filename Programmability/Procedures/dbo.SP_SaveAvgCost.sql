SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SaveAvgCost](@ItemStoreNo Uniqueidentifier,
@Qty decimal,
@NetCost money,
@CaseQty decimal =1)
AS

Declare @Final money

SET @Final = @NetCost / @CaseQty

BEGIN

declare @AVGCost money
Declare @OnHand decimal
Declare @MyItemID Uniqueidentifier
Set @MyItemID = (Select TOP(1) ItemNo From ItemStore Where ItemStoreID = @ItemStoreNo)
Set @OnHand = (SELECT SUM(IsNull(OnHand,0))From ItemStore WHERE ItemNo=@MyItemID)


BEGIN TRY
  IF @OnHand <=0 
    SET @AVgCost = @Final
  ELSE
    SET @AVGCost =(SELECT ((@OnHand*ISnull(AVGCost,Cost))+(@Qty*@Final))/ (CASE WHEN @OnHand +@Qty<>0 THEN(@OnHand +@Qty)WHEN @Qty<>0 THEN @QTY ELSE 1 END) 
	FROM ItemStore 
	where ItemStoreID=@ItemStoreNo)

IF (@AVGCost > (@Final*3)) OR (@AVGCost < -(@Final*3))
  set @AVgCost = @Final
END TRY
BEGIN CATCH
  SET @AVgCost = @Final
END CATCH


insert into itemStoreOnHandAvgCustHistory (ItemStoreId  ,ItemNo  ,AVGCost   , OnHand  ,PcCost  ,Qty   ,DateModified )
select ItemStoreId  ,ItemNo  ,AVGCost   , OnHand  ,@Final  ,@Qty   ,dbo.GetLocalDATE()
from ItemStore 
Where ItemNo = @MyItemID


Update ItemStore Set AVGCost = @AVGCost, DateModified = dbo.GetLocalDATE() Where ItemNo = @MyItemID

END
GO