SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferOrderEntryUpdate]

(@TransferOrderEntryID uniqueidentifier,
@TransferOrderID uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@UOMPrice Money, 
@Qty decimal,
@UOMQty decimal,
@UOMType int,
@LinkNo uniqueidentifier,
@Note nvarchar(4000), 
@SortOrder int,
@Status  smallint, 
@DateModified Datetime,
@ModifierID uniqueidentifier)

AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()


UPDATE  dbo.TransferOrderEntry              
SET    	TransferOrderID = @TransferOrderID, 
	ItemStoreNo =@ItemStoreNo,  
	UOMPrice = @UOMPrice, 
	Qty = @Qty,  
	UOMQty = @UOMQty, 
	UOMType= @UOMType, 
	Note = @Note, 
        SortOrder=@SortOrder,
	Status = @Status,  
	DateModified = @UpdateTime,        
        UserModified = @ModifierID
WHERE  (TransferOrderEntryID = @TransferOrderEntryID) and
     (  (DateModified = @DateModified) OR (DateModified is NULL)  Or
         (@DateModified is null)
      )

select @UpdateTime as DateModified
GO