SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PhoneOrderEntryUpdate]

(@PhoneOrderEntryID uniqueidentifier,
@PhoneOrderID uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@UOMPrice Money, 
@ExtPrice Money, 
@Qty decimal (18,2),
@UOMQty decimal,
@UOMType int,
@LinkNo uniqueidentifier,
@Note nvarchar(4000), 
@SortOrder int,
@OnHand decimal(19, 3) = null,
@Status  smallint, 
@DateModified Datetime,
@ModifierID uniqueidentifier,
@Name nvarchar (50),
@BarCode nvarchar( 50),
@ModalNo nvarchar (50))

AS

UPDATE  dbo.PhoneOrderEntry              
SET    	
	PhoneOrderID =@PhoneOrderID,  
	ItemStoreNo = @ItemStoreNo, 
	UOMPrice = @UOMPrice, 
	ExtPrice=@ExtPrice, 
	Qty = @Qty,  
	UOMQty = @UOMQty, 
	UOMType= @UOMType, 
	Note = @Note, 
	SortOrder=@SortOrder,
	Onhand = @OnHand ,
Status = @Status,  
	DateModified = dbo.GetLocalDATE(),        
	UserModified = @ModifierID

WHERE  (PhoneOrderEntryID = @PhoneOrderEntryID) and
      ( (DateModified = @DateModified) OR (DateModified is NULL)  Or
         (@DateModified is null) )
GO