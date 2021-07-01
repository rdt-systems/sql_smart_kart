SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_RequestTransferUpdate]
(@RequestTransferID uniqueidentifier,
@RequestDate datetime,
@RequestNo nvarchar(50),
@FromStoreID uniqueidentifier,
@ToStoreID uniqueidentifier,
@Note nvarchar(4000),
@UserModified uniqueidentifier,
@DateModified datetime,
@Status smallint,
@ModifierID uniqueidentifier,
@RequestStatus int)
AS



Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Update      dbo.RequestTransfer
Set         RequestNo=@RequestNo,
			FromStoreID=@FromStoreID,
			ToStoreID=@ToStoreID,
			RequestDate=@RequestDate,
 			Note=@Note,
 			Status=@Status,
 			DateCreated=@UpdateTime,
 			UserCreated=@ModifierID,
 			DateModified=@UpdateTime,
 			UserModified=@ModifierID,
			RequestStatus=@RequestStatus
where RequestTransferID=@RequestTransferID and
     (  (DateModified = @DateModified) OR (DateModified is NULL)  Or
         (@DateModified is null)
      )
GO