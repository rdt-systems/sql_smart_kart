SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DeliveryDetailsUpdate]
(@DeliveryDetailID uniqueidentifier,
@Driver uniqueidentifier,
@ShippedDate DateTime,
@DeliverdDate DateTime,
@ReturnedDate DateTime,
@Status Int,
@BatchID int)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Begin

IF @status = 1
UPDATE dbo.DeliveryDetails
SET Driver=@Driver,ShippedDate=@ShippedDate, Status=@Status,DateModified=dbo.GetLocalDATE(),BatchID = @BatchID
WHERE (DeliveryDetailID=@DeliveryDetailID)

IF @status = 2
UPDATE dbo.DeliveryDetails
SET Driver=@Driver,ShippedDate=@ShippedDate, Status=@Status,DateModified=dbo.GetLocalDATE(), BatchID = @BatchID
WHERE (DeliveryDetailID=@DeliveryDetailID)
       
IF @status = 6
UPDATE dbo.DeliveryDetails
SET Driver=@Driver,DeliverdDate=@DeliverdDate, Status=@Status,DateModified=dbo.GetLocalDATE(),BatchID = @BatchID
WHERE (DeliveryDetailID=@DeliveryDetailID)

IF @status = 4
UPDATE dbo.DeliveryDetails
SET Driver=@Driver,ReturnedDate=@ReturnedDate, Status=@Status,DateModified=dbo.GetLocalDATE(),BatchID = @BatchID
WHERE (DeliveryDetailID=@DeliveryDetailID)

IF @Status = 7
update dbo.DeliveryDetails 
set Driver=@driver,ShippedDate =@ShippedDate , Status =@Status , DateModified = dbo.GetLocalDATE(),BatchID = @BatchID
where (DeliveryDetailID=@DeliveryDetailID )

IF @Status = 8
update dbo.DeliveryDetails 
set Driver=@driver, ShippedDate =@ShippedDate , Status =@Status , DateModified = dbo.GetLocalDATE(),BatchID = @BatchID
where (DeliveryDetailID=@DeliveryDetailID )

IF @Status = 9
update dbo.DeliveryDetails 
set Driver=@driver,ShippedDate =@ShippedDate , Status =@Status , DateModified = dbo.GetLocalDATE(),BatchID = @BatchID
where (DeliveryDetailID=@DeliveryDetailID )

End
GO