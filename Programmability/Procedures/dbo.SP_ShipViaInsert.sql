SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ShipViaInsert]
(@ShipViaID uniqueidentifier,
@ShipViaName nvarchar(50),
@Status smallint,
@ModifierId uniqueidentifier)

AS INSERT INTO dbo.ShipVia
                      (ShipViaID, ShipViaName, Status, DateModified, UserModified)

VALUES     (@ShipViaID, @ShipViaName, 1,dbo.GetLocalDATE() ,@ModifierId)
GO