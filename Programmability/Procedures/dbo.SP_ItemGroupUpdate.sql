SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemGroupUpdate]
(@ItemGroupID uniqueidentifier,
@ItemGroupName nvarchar(50),
@ParentID uniqueidentifier,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE  dbo.ItemGroup

SET     ItemGroupName= dbo.CheckString(@ItemGroupName), ParentID=@ParentID, Status = @Status, DateModified=@UpdateTime, UserModified= @ModifierID
	
WHERE  (ItemGroupID= @ItemGroupID) AND (DateModified = @DateModified OR DateModified IS NULL)

select @UpdateTime as DateModified
GO