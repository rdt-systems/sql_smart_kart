SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSeasonDelete]
(@ItemStoreSeasonId uniqueidentifier,
@ModifierID uniqueidentifier)

AS
UPDATE  dbo.ItemSeason
 
SET        Status = -1, DateModified = dbo.GetLocalDATE()
                   
WHERE   ItemStoreSeasonId = @ItemStoreSeasonId
GO