SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SavedFiltersUpdate]
(@FilterID uniqueidentifier,
@FilterName nvarchar,
@FilterValue nvarchar, 
@Category int,
@HasItem bit,
@Status smallint,
@UserCreated uniqueidentifier,
@DateModified	datetime,
@ModifierID	uniqueidentifier)

AS update dbo.SavedFilters
set

FilterID=@FilterID,
FilterName=@FilterName,
FilterValue=@FilterValue,
Category=@Category,
HasItem=@HasItem,
Status = @Status,
UserCreated=@UserCreated,
DateModified=dbo.GetLocalDATE(),
UserModified=@ModifierID
GO