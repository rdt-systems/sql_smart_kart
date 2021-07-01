SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		Eziel
-- ALTER date: 9/10/12
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SP_SaveGiftRegistry] 
	-- Add the parameters for the stored procedure here
	@CustomerID uniqueidentifier , 
	@EventDate datetime, 
	@EventType nvarchar(20),
	@Status int
	
	AS
BEGIN

 IF EXISTS(SELECT * From GiftRegistery where CustomerID = @CustomerID AND Status > 0) 
    UPDATE GiftRegistery Set EventDate = @EventDate, EventType = @EventType, Status = @Status, DateModified = dbo.GetLocalDATE() WHERE CustomerID = @CustomerID AND Status > 0
	ELSE
	INSERT INTO GiftRegistery (CustomerID, EventDate, EventType, Status, DateCreated) VALUES (@CustomerID, @EventDate, @EventType , 1 , dbo.GetLocalDATE())
	
	--Return (Select GiftRegisteryID from GiftRegistery WHERE CustomerID = @CustomerID and Status > 0)
	
END
GO