SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GettestError]
(@Filter nvarchar(4000))

as

select testTable.DateCreated
from testTable join ItemStore on testTable.ItemID=ItemStore.ItemNo
GO