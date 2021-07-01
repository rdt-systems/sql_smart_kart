SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TitleContactInsert]
(@TitleContactID uniqueidentifier,
@TitleName nvarchar(50),
@Type smallint,
@Status smallint,
@ModifierID uniqueidentifier)
AS 
--INSERT INTO dbo.TitleContactView
--                      (TitleContactID, TitleName,Type, Status, DateCREATE, UserCREATE, DateModified, UserModified)
--VALUES     (@TitleContactID, @TitleName,@Type, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO