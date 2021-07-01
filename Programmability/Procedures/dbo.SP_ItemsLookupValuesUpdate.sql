SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemsLookupValuesUpdate]
(@ValueId uniqueidentifier,
@ValueType smallint,
@ValueName nvarchar(50),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

 UPDATE dbo.ItemsLookupValues

SET	ValueName=dbo.CheckString(@ValueName),
 ValueType =@ValueType,
	Status=@Status,
	DateModified=@UpdateTime,
	UserModified=@ModifierID

WHERE	(ValueId=@ValueId) AND 
      (DateModified = @DateModified OR DateModified IS NULL)



select @UpdateTime as DateModified
GO