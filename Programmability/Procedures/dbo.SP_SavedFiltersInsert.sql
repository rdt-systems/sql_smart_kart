SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SavedFiltersInsert]
(@FilterID uniqueidentifier,
@FilterName nvarchar(50),
@FilterValue nvarchar(4000), 
@Category int,
@HasItem bit,
@Status smallint,
@ModifierID	uniqueidentifier)

AS INSERT INTO dbo.SavedFilters

(FilterID,FilterName,FilterValue,Category, HasItem,   Status  ,DateCreated,UserCreated,DateModified,UserModified)
values (@FilterID,@FilterName,@FilterValue,@Category,@HasItem, 1,dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID)
GO