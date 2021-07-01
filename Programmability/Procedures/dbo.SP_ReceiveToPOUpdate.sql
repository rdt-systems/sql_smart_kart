SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveToPOUpdate]
(@ReceiveToPOID uniqueidentifier,
@ReceiveID uniqueidentifier,
@POID uniqueidentifier,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)


AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE     dbo.ReceiveToPO
                 
 SET     ReceiveID= @ReceiveID ,POID= @POID, Status =@Status, DateModified = @UpdateTime, UserModified = @ModifierID

 WHERE (ReceiveToPOID = @ReceiveToPOID) and  (DateModified = @DateModified or DateModified is NULL)


select @UpdateTime as DateModified
GO