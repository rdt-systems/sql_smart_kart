SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ShipViaDelete]
(@ShipViaID uniqueidentifier,
@ModifierId uniqueidentifier)
As
Update dbo.ShipVia

 SET       status =-1,  DateModified = dbo.GetLocalDATE(), UserModified=@ModifierId

WHERE ShipViaID = @ShipViaID
GO