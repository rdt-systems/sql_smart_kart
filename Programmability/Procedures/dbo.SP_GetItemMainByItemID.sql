SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemMainByItemID]
(@ItemID uniqueidentifier)
As 


select * from dbo.ItemMain
where ItemID=@ItemID
GO