SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferItemsInsert]
(@TransferID uniqueidentifier,
@TransferNo nvarchar(50),
@FromStoreID uniqueidentifier,
@ToStoreID uniqueidentifier,
@TransferDate datetime,
@Note nvarchar(4000),
@PersonID uniqueidentifier,
@Status smallint,
@ModifierID uniqueidentifier)
AS

INSERT INTO dbo.TransferItems
                      (TransferID,  TransferNo,FromStoreID  ,ToStoreID  ,TransferDate, Note,PersonID, Status, DateCreated, UserCreated, DateModified, UserModified,TransferStatus)
VALUES                (@TransferID, @TransferNo, @FromStoreID, @ToStoreID, @TransferDate, @Note,@PersonID,      1,   dbo.GetLocalDATE(), @ModifierID,    dbo.GetLocalDATE(),  @ModifierID,1)


exec UpdateOnHandByTransfer @TransferID =@TransferID,@ModifierID = @ModifierID
GO