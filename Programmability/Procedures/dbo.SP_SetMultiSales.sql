SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE proc [dbo].[SP_SetMultiSales]
(@SaleID uniqueidentifier,
 @ModifierID uniqueidentifier)
as
 Update Sales 
 Set AllowMultiSales=1,
 DateMOdified=dbo.GetLocalDATE(),
 UserModified=@ModifierID
 where SaleID=@SaleID
GO