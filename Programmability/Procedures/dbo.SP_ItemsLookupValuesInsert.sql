SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemsLookupValuesInsert]
(@ValueType int ,
@ValueID uniqueidentifier,
@ValueName varchar(50) ,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.ItemsLookupValues
                      (ValueType, ValueID,ValueName, Status,DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@ValueType,@ValueID, dbo.CheckString(@ValueName), 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO