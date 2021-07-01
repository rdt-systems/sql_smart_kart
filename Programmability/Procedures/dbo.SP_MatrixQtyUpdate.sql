SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_MatrixQtyUpdate]
(@ItemStoreID uniqueidentifier,
 @ReorderPoint int,
 @RestockLevel int,
 @Price money =0,
 @Cost money =0)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

IF @Price <>0 
BEGIN
	UPDATE    dbo.ItemStore 
	SET    ReorderPoint =@ReorderPoint ,RestockLevel =@RestockLevel ,DateModified =@UpdateTime,Price =@Price, Cost = @Cost  
	WHERE  ItemStoreID =@ItemStoreID 
END
ELSE BEGIN
	UPDATE    dbo.ItemStore 
	SET    ReorderPoint =@ReorderPoint ,RestockLevel =@RestockLevel ,DateModified =@UpdateTime   
	WHERE  ItemStoreID =@ItemStoreID 
END
GO