SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_BuyersDelete]
(@BuyerID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 

Update Buyers Set Status = -1, DateModified = dbo.GetLocalDate(), UserModified = @ModifierID  Where BuyerID = @BuyerID
GO