SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE View [dbo].[ActivityView] as
select ActivityID, (case Tablename when 1 then 'ItemList' end) as TableNameDesc, users.Username, 
(Case Activity.Status when 1 then 'Activated' when 0 then 'Inactivated' end) as Status, Description,Activity.DateCreated, RowID
from Activity
inner join Users on Activity.UserID = users.UserId
GO