SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Insert_Delivery]  
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
	
	INSERT INTO [dbo].[Delivery] ([Road],[DeliveryDate] ,	[Assigned],[Status] ,[Note]) 
		VALUES (@Road,@DeliveryDate ,@Assigned,@Status ,@Note)

END
GO