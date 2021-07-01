SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SaleToTenderDelete]
(@SaleToTenderID	uniqueidentifier,
@ModifierID uniqueidentifier)
as
update SaleToTender
set Status=-1, datemodified=dbo.GetLocalDATE(),UserModified=@ModifierID
where SaleToTenderID=@SaleToTenderID
and status>0
GO