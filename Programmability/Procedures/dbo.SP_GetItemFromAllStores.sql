SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemFromAllStores]
(@ItemNo uniqueidentifier,
@AllChildAllStores bit = 0)

AS
if @AllChildAllStores = 0
begin
	select *
	from dbo.ItemStore
	where ItemNo=@ItemNo AND Status>-1
end
else
--Alex Abreu
--1/29/2015
--Update all childs on all stores
begin
	select * from ItemStore where (ItemNo in (
	select ItemID from ItemMain where LinkNo = @ItemNo) OR (ItemNo=@ItemNo)) AND Status>-1
end
GO