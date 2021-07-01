SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSeasonUpdate]
(@ItemStoreSeasonId uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@SeasonNo uniqueidentifier,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE  dbo.ItemSeason
 
SET        ItemStoreNo = @ItemStoreNo, SeasonNo = @SeasonNo, Status =@Status, DateModified = @UpdateTime
                   
WHERE   (ItemStoreSeasonId = @ItemStoreSeasonId) AND 
      (DateModified = @DateModified OR DateModified IS NULL)


select @UpdateTime as DateModified
GO