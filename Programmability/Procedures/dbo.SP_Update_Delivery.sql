SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Update_Delivery]  
	@DeliveryID int,  
	@Road varchar(25),
	@DeliveryDate datetime,
	@Assigned char(30),
	@Status int,
    @Note char(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	UPDATE [dbo].[Delivery] 
		SET [Road] = @Road,
			[DeliveryDate] = @DeliveryDate,
		 	[Assigned] = @Assigned,
			[Status] = @Status,
			[Note] = @Note
		WHERE
            [DeliveryID] = @DeliveryID  
END
GO