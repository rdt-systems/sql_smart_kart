SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferOrderUpdate]
(@TransferOrderID uniqueidentifier,
@TransferOrderNo nvarchar(50),
@FromStoreID uniqueidentifier,
@ToStoreID uniqueidentifier,
@TransferOrderDate datetime,
@Note nvarchar(4000),
@PersonID uniqueidentifier,
@OrderStatus Int,
@Status smallint,
@DateModified Datetime,
@ModifierID uniqueidentifier)
AS

exec UpdateOnOrderAndOnTransfer @TransferOrderID,-1,@ModifierID

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Update      dbo.TransferOrder
Set         TransferOrderNo=@TransferOrderNo,
			FromStoreID=@FromStoreID,
			ToStoreID=@ToStoreID,
			TransferOrderDate=@TransferOrderDate,
 			Note=@Note,
			PersonID=@PersonID,
            OrderStatus = @OrderStatus,
 			Status=@Status,
 			DateCreated=@UpdateTime,
 			UserCreated=@ModifierID,
 			DateModified=@UpdateTime,
 			UserModified=@ModifierID
where TransferOrderID=@TransferOrderID and
     (  (DateModified = @DateModified) OR (DateModified is NULL)  Or
         (@DateModified is null)
      )
GO