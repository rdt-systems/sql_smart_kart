SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GeneralSaleDelete]
(@GeneralSaleID uniqueidentifier,
@ModifierID uniqueidentifier)
AS UPDATE    dbo.GeneralSale
SET              Status = -1, DateModified = dbo.GetLocalDATE()
WHERE  GeneralSaleID = @GeneralSaleID
GO