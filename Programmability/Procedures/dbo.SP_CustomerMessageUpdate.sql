SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_CustomerMessageUpdate]
(@CustomerMessageID uniqueidentifier,
@Message nvarchar(50),
@IsDefault bit,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS


Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

update  customermessage

set 	Message=@Message,
	IsDefault=@IsDefault,
	Status=@Status,
	DateModified= @UpdateTime,
	UserModified=@ModifierID

where  (CustomerMessageID=@CustomerMessageID)
	and (DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO