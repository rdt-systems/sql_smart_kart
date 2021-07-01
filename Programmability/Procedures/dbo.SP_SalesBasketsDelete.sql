SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SalesBasketsDelete]
(@BasketID	uniqueidentifier,
@ModifierID uniqueidentifier)
as
update SalesBaskets
set Status=-1, datemodified=dbo.GetLocalDATE(),UserModified=@ModifierID
where BasketID=@BasketID
GO