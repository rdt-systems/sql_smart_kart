SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_Update_DeliveryDetails] 
	@DeliveryID Int,  
	@DeliveryDetailID uniqueidentifier,
	@ShippingAdress uniqueidentifier,
	@Status int,
    @Note char(500),
    @OrderTypeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	UPDATE [dbo].[DeliveryDetails] 
		SET [ShippingAdress] = @ShippingAdress,
			[Status] = @Status,
			[Note] = @Note,
			[OrderTypeID] = @OrderTypeID
		WHERE
            [DeliveryID] = @DeliveryID AND [DeliveryDetailID] = @DeliveryDetailID  
END
GO