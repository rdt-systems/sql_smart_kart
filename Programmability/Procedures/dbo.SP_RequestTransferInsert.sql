SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_RequestTransferInsert]
(@RequestTransferID uniqueidentifier,
@RequestDate datetime,
@RequestNo nvarchar(50),
@FromStoreID uniqueidentifier,
@ToStoreID uniqueidentifier,
@Note nvarchar(4000),
@RequestStatus int,
@UserModified uniqueidentifier=null,
@Status smallint,
@ModifierID uniqueidentifier=null
)
AS

INSERT INTO dbo.RequestTransfer
                      (RequestTransferID,RequestDate, RequestNo, FromStoreID, ToStoreID,Note,RequestStatus,Status, DateCreated, DateModified, UserCreated, UserModified)
VALUES                (@RequestTransferID,@RequestDate, @RequestNo    ,@FromStoreID, @ToStoreID, @Note,0, 1, dbo.GetLocalDATE(), dbo.GetLocalDATE(),@ModifierID, @ModifierID)
GO