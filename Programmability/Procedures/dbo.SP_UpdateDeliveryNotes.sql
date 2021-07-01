SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


Create PROCEDURE [dbo].[SP_UpdateDeliveryNotes]
(@TransactionID uniqueidentifier,
@Note nvarchar(50))
as
Update DeliveryDetails 
set 
Note = @Note 
where TransactionID=@TransactionID
GO