SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SalesIncentiveHeaderView]
AS
SELECT        dbo.SalesIncentiveHeader.*, dbo.Users.UserName
FROM            dbo.SalesIncentiveHeader LEFT OUTER JOIN
                         dbo.Users ON dbo.SalesIncentiveHeader.UserCreated = dbo.Users.UserId
WHERE        (dbo.SalesIncentiveHeader.Status > 0)
GO