SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GiftTypeUpdate]
(@GiftTypeId uniqueidentifier,
@GiftName nchar(50),
@IsAutoNo bit,
@IsReqNo bit,
@IsHaveExp bit,
@DaysToExp int,
@status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS 

--Declare @UpdateTime datetime
--set  @UpdateTime =dbo.GetLocalDATE()

--UPDATE     dbo.giftType
--SET              GiftName = dbo.CheckString(@GiftName),
--                    IsAutoNo = @IsAutoNo, 
--                    IsReqNo = @IsReqNo,
--                    IsHaveExp = @IsHaveExp,
--                    DaysToExp= @DaysToExp, 
--                    Status = @Status, 
--                    DateModified = @UpdateTime, 
--                    UserModified = @ModifierID

--WHERE     (GiftTypeId = @GiftTypeId) AND 
--      (DateModified = @DateModified OR DateModified IS NULL)


--select @UpdateTime as DateModified
GO