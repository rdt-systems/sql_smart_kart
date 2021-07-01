SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Delete_DeliveryDetails]  
	@DeliveryID int,  
	@DeliveryDetailID uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DELETE FROM [dbo].[DeliveryDetails] WHERE
		         [DeliveryID] = @DeliveryID AND [DeliveryDetailID] = @DeliveryDetailID  
END
GO