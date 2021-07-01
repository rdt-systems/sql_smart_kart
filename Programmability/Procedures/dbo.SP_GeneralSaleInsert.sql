SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GeneralSaleInsert]
(@GeneralSaleID uniqueidentifier,
@DiscountID uniqueidentifier,
@StartDate datetime,
@EndDate datetime,
@ModifierID uniqueidentifier,
@Status smallint)
AS INSERT INTO dbo.GeneralSale
                      (GeneralSaleID, DiscountID, StartDate, EndDate,  Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@GeneralSaleID, @DiscountID, @StartDate, @EndDate,  1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO