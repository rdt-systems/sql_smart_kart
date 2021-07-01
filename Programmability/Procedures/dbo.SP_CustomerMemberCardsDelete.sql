SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_CustomerMemberCardsDelete]
(@CardID uniqueidentifier,
@ModifierID uniqueidentifier)
AS

update  CustomerMemberCards

set 	
	Status=-1,
	DateModified= dbo.GetLocalDATE(),
	UserModified=@ModifierID

where  (CardID=@CardID)
GO