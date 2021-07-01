SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferItemsUpdate]
(@TransferID uniqueidentifier,
@TransferNo nvarchar(50),
@FromStoreID uniqueidentifier,
@ToStoreID uniqueidentifier,
@TransferDate datetime,
@Note nvarchar(4000),
@PersonID uniqueidentifier,
@Status smallint,
@DateModified Datetime,
@ModifierID uniqueidentifier)
AS



Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Update      dbo.TransferItems
Set         TransferNo=@TransferNo,
			FromStoreID=@FromStoreID,
			ToStoreID=@ToStoreID,
			TransferDate=@TransferDate,
 			Note=@Note,
			PersonID=@PersonID,
 			Status=@Status,
 			DateCreated=@UpdateTime,
 			UserCreated=@ModifierID,
 			DateModified=@UpdateTime,
 			UserModified=@ModifierID
where TransferID=@TransferID and
     (  (DateModified = @DateModified) OR (DateModified is NULL)  Or
         (@DateModified is null)
      )



IF @Status <1 BEGIN
Update TransferEntry Set Status = @Status, DateModified = dbo.GetLocalDATE() WHERE TransferID = @TransferID
END

exec UpdateOnHandByTransfer @TransferID,-1,@ModifierID
GO