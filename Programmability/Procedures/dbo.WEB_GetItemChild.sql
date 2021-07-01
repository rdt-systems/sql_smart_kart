SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WEB_GetItemChild]
(@ItemStoreID uniqueidentifier)
as
declare @ItemID uniqueidentifier
set @ItemID=(select itemID from itemmainandstoreview where status>0 and ItemStoreID=@ItemStoreID)

select matrix1, linkno,itemstoreid,Price
from itemmainandstoreview
where status>0 and itemtype=1
and linkno=@ItemID
order by matrix1
GO