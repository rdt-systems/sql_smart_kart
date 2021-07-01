SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesBasketsUpdate]
(
		@BasketID uniqueidentifier
       ,@SaleID uniqueidentifier
       ,@BaskItemID uniqueidentifier
       ,@BaskActionType bit
       ,@BaskItemType int
	   ,@SupplierID uniqueidentifier
       ,@QtyBasket int
       ,@MinQty decimal
       ,@Status	smallint
	   ,@DateModified datetime	
	   ,@ModifierID uniqueidentifier
)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE [dbo].[SalesBaskets]
   SET [SaleID] = @SaleID
      ,[BaskItemID] = @BaskItemID
      ,[BaskActionType] = @BaskActionType
      ,[BaskItemType] = @BaskItemType
      ,[SupplierID] = @SupplierID
      ,[Status]=@Status
      ,QtyBasket=@QtyBasket
      ,MinQty =@MinQty
	  ,DateModified =@UpdateTime
	  ,UserModified = @ModifierID	

 WHERE	[BasketID] = @BasketID AND 
		(DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO