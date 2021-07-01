SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_CustomerMessageInsert]
(@CustomerMessageID uniqueidentifier,
@Message nvarchar(50),
@IsDefault bit,
@Status smallint,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

	insert into customermessage(CustomerMessageID,Message,IsDefault,
				Status,DateCreated,UserCreated,DateModified,UserModified)
	values(@CustomerMessageID,@Message,@IsDefault,
		1,@UpdateTime,@ModifierID,@UpdateTime,@ModifierID)
 


select @UpdateTime as DateModified
GO