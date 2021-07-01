SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSeasonInsert]
(@ItemStoreSeasonId uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@SeasonNo uniqueidentifier,
@Status smallint,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.ItemSeason
                      (ItemStoreSeasonId, ItemStoreNo,SeasonNo,Status,  DateModified)
VALUES     (@ItemStoreSeasonId, @ItemStoreNo,@SeasonNo, 1,  dbo.GetLocalDATE())
GO