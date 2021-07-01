SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SearchItemByName]
(
	@Name nvarchar(4000),
	@StoreID uniqueidentifier
)
AS
BEGIN
	Set @Name = '"*' + @Name + '*"'

	   	Select ItemID From 
		ItemMain im inner join ItemStore i on i.ItemNo = im.ItemID
		Where i.Status > 0 and  Contains(Name,  @Name) AND im.Status > 0 AND StoreNo = @StoreID 
END
GO