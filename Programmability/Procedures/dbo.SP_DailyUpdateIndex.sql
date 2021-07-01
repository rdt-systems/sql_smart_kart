SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DailyUpdateIndex]
AS
------------------
Exec SP_DailyUpdateRunningBalance
------------------
EXEC SP_UpdateAllRuningBalance @Days = 15
--------------------
Exec OnHandUpdate
--------------------
delete f  FROM (SELECT ROW_NUMBER() OVER (PARTITION BY SupplierNo, ItemStoreNo  ORDER BY SupplierNo, ItemStoreNo ) AS DupeCount
FROM ItemSupply Where Status>0) AS f WHERE DupeCount > 1
---------------------
Update UsersStore set Status=1,datemodified=dbo.GetLocalDATE() where Status<1 and  userid in(select Userid from Users where status >0)
and userid not in(select UserID From UsersStore where Status>0)
---------------------
update ItemStore set Status= 1,datemodified=dbo.GetLocalDATE() where Status<1 and ItemNo IN(select ItemID from ItemMain where Status>0) and Status<1
---------------------
GO