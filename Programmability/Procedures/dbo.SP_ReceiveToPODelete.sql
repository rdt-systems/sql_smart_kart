SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveToPODelete]
(@ReceiveToPOID uniqueidentifier,
@ModifierID uniqueidentifier)


AS 

UPDATE     dbo.ReceiveToPO
                 
 SET     Status =-1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
 WHERE ReceiveToPOID = @ReceiveToPOID
GO