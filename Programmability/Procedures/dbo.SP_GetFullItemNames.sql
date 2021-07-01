SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetFullItemNames]
(@StoreID uniqueidentifier,
@Alias bit  =0)
as
if @Alias=1
	Select * from dbo.FullItemNamesWithAlias
	where --(StoreNo=@StoreID) and 
	(MainStatus=1) and (StoreStatus=1)
	ORDER BY FullName
else
	Select * from dbo.FullItemNames
	where (StoreNo=@StoreID) and (MainStatus=1) and (StoreStatus=1) 
	ORDER BY FullName
GO