SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesBasketsInsert]
(
		@BasketID uniqueidentifier
       ,@SaleID uniqueidentifier
       ,@BaskItemID uniqueidentifier
       ,@BaskActionType int
       ,@BaskItemType int
       ,@SupplierID uniqueidentifier
       ,@QtyBasket int
       ,@MinQty decimal
       ,@Status	smallint	
	   ,@ModifierID uniqueidentifier)

AS

INSERT INTO [dbo].[SalesBaskets]
           ([BasketID]
           ,[SaleID]
           ,[BaskItemID]
           ,[BaskActionType]
           ,[BaskItemType]
           ,[SupplierID]
           ,[QtyBasket]
           ,[MinQty]   
           ,[Status]
           ,[DateCreated]
           ,[UserCreated]
           ,[DateModified]
           ,[UserModified])
     VALUES
           (@BasketID
           ,@SaleID
           ,@BaskItemID
           ,@BaskActionType
           ,@BaskItemType
           ,@SupplierID
           ,@QtyBasket
           ,@MinQty
           ,isnull(@Status,1)
           ,dbo.GetLocalDATE()
           ,@ModifierID
           ,dbo.GetLocalDATE()
           ,@ModifierID)
GO