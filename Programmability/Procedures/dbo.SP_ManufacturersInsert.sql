SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ManufacturersInsert]
(@ManufacturerID uniqueidentifier,
@ManufacturerName nvarchar(50),
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.Manufacturers
                      (ManufacturerID, ManufacturerName, Status,DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@ManufacturerID, dbo.CheckString(@ManufacturerName), 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO