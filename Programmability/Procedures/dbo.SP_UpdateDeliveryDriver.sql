SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateDeliveryDriver]
	-- Add the parameters for the stored procedure here
	(@BatchId Int,
	@UserId uniqueidentifier)
AS

Update DeliveryDetails 
set Driver = @UserId , Status = 2,ShippedDate = dbo.GetLocalDATE()
where BatchID = @BatchId and Status = 7
GO