SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Void_Orders] 
	@DeliveryDetailID uniqueidentifier,
	@Status int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	UPDATE [dbo].[DeliveryDetails] 
		SET [Status] = @Status
		WHERE
            [DeliveryDetailID] = @DeliveryDetailID  
END
GO