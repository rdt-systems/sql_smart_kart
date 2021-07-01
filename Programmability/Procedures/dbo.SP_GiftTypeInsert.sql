SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftTypeInsert]
(@GiftTypeId uniqueidentifier,
@GiftName nchar(50),
@IsAutoNo bit,
@IsReqNo bit,
@IsHaveExp bit,
@DaysToExp int,
@status smallint,
@ModifierID uniqueidentifier)

AS 
--INSERT INTO dbo.GiftType
--                      (GiftTypeId, GiftName, IsAutoNo, IsReqNo, IsHaveExp, DaysToExp, Status, DateCREATE, UserCREATE, DateModified, UserModified)
--VALUES     (@GiftTypeId, dbo.CheckString(@GiftName), @IsAutoNo, @IsReqNo, @IsHaveExp, @DaysToExp, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO