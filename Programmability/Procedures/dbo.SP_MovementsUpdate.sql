SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_MovementsUpdate]
(@ActionType int,
@MovementType nvarchar(3),
@Details nvarchar(50),
@DebitAccount nvarchar(8),
@CreditAccount nvarchar(8),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
as
UPDATE [dbo].[Movements]
   SET [MovementType] = @MovementType,
	   [Details]=@Details,
       [DebitAccount] = @DebitAccount,
       [CreditAccount] = @CreditAccount,
       [Status] = @Status,
	   [DateModified]=dbo.GetLocalDATE(),
	   [UserModified]=@ModifierID

WHERE [ActionType] = @ActionType  and (DateModified=@datemodified or @datemodified is null)
GO