SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferOrderInsert]
(@TransferOrderID uniqueidentifier,
@TransferOrderNo nvarchar(50),
@FromStoreID uniqueidentifier,
@ToStoreID uniqueidentifier,
@TransferOrderDate datetime,
@Note nvarchar(4000),
@PersonID uniqueidentifier,
@OrderStatus Int,
@Status smallint,
@ModifierID uniqueidentifier)
AS

INSERT INTO dbo.TransferOrder
                      (TransferOrderID,  TransferOrderNo,FromStoreID  ,ToStoreID  ,TransferOrderDate, Note,PersonID,OrderStatus, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES                (@TransferOrderID, @TransferOrderNo, @FromStoreID, @ToStoreID, @TransferOrderDate, @Note,@PersonID,@OrderStatus,      1,   dbo.GetLocalDATE(), @ModifierID,    dbo.GetLocalDATE(),  @ModifierID)
GO