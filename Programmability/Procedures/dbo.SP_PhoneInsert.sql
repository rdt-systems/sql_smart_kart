SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PhoneInsert](@PhoneID uniqueidentifier,
@PhoneType int,
@PhoneNumber nvarchar(50),
@SortOrder smallint)
AS INSERT INTO dbo.Phone
                      (PhoneID, PhoneType, PhoneNumber, SortOrder, Status, DateModified)
VALUES     (@PhoneID, @PhoneType, @PhoneNumber, @SortOrder, 1, dbo.GetLocalDATE())
GO