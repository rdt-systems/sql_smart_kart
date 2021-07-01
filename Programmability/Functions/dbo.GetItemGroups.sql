SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE    FUNCTION [dbo].[GetItemGroups](@ItemStoreID uniqueidentifier)
RETURNS nvarchar(4000)  AS  
BEGIN 
	DECLARE @Groups VARCHAR(1000)
	SET @Groups=''
	SELECT @Groups=@Groups + ',' + dbo.ItemGroup.ItemGroupName 
	FROM         dbo.ItemGroup INNER JOIN
                      dbo.ItemToGroup ON dbo.ItemGroup.ItemGroupID = dbo.ItemToGroup.ItemGroupID
	WHERE     (dbo.ItemToGroup.ItemStoreID =@ItemStoreID) And(dbo.ItemToGroup.Status>0)
	ORDER BY dbo.ItemGroup.ItemGroupName
        SET @Groups=substring(@Groups,2,4000)

return @Groups
END
GO