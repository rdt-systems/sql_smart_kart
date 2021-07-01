SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_MovementsInsert]
(@ActionType int,
@MovementType nvarchar(3),
@Details nvarchar(50),
@DebitAccount nvarchar(8),
@CreditAccount nvarchar(8),
@Status smallint,
@ModifierID uniqueidentifier)

as

INSERT INTO [dbo].[Movements]
           ([ActionType]
           ,[MovementType]
		   ,[Details]
           ,[DebitAccount]
           ,[CreditAccount]
           ,[Status],DateCreated,UserCreated,DateModified,UserModified)
     VALUES
           (@ActionType,
            @MovementType,
			@Details,
            @DebitAccount, 
            @CreditAccount,
            isnull(@Status,1),dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID)
GO