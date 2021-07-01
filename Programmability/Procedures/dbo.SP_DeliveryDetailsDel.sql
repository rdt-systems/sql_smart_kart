SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DeliveryDetailsDel]
(@DeliveryDetailID uniqueidentifier,
@Status Int)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Begin

  
UPDATE dbo.DeliveryDetails

SET Status=@Status,DateModified=dbo.GetLocalDATE()
        
WHERE (DeliveryDetailID=@DeliveryDetailID)

End
GO