SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_UpdateDeliveryDate]
(@TransactionID uniqueidentifier,
@BeDeliverdDate datetime) 

as
 

Update DeliveryDetails 

set 
BeDeliverdDate = @BeDeliverdDate,
DateModified = dbo.GetLocalDATE()
where TransactionID=@TransactionID
GO