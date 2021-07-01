SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE proc [dbo].[SP_SetPriority]
(@SaleID uniqueidentifier,
 @Priority int,
 @ModifierID uniqueidentifier)
as
 Update Sales 
 Set Priority=@Priority,
 DateMOdified=dbo.GetLocalDATE(),
 UserModified=@ModifierID
 where SaleID=@SaleID
GO