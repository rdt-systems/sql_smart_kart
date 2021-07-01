SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Insert_DeliveryDetails]
	@DeliveryID int,  
	@ShippingAdress uniqueidentifier,
	@Status int,
    @Note char(500),
    @OrderTypeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	INSERT INTO [dbo].[DeliveryDetails] ([DeliveryID],[ShippingAdress] ,[Status] ,[Note],[OrderTypeID]) 
								 VALUES (@DeliveryID,@ShippingAdress ,@Status,@Note ,@OrderTypeID)

END
GO