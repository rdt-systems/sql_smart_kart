SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[RegisterKeysView]
AS
SELECT     dbo.RegisterKeys.RegisterKeyID, dbo.RegisterKeys.ActionID, dbo.RegisterKeys.ActionKey, dbo.RegisterKeys.ShiftType, ISNULL(dbo.RegisterKeys.IsAction,1) AS IsAction, 
                      ISNULL(dbo.RegisterKeys.IsButton,1) AS IsButton, dbo.RegisterKeys.Status, dbo.RegisterKeys.DateCreated, dbo.RegisterKeys.UserCreated, dbo.RegisterKeys.DateModified, 
                      dbo.RegisterKeys.UserModified, 
                      CASE WHEN isaction = 1 THEN SystemValueName COLLATE Hebrew_CI_AS ELSE ActionID COLLATE Hebrew_CI_AS END AS Action, 
                      CASE WHEN isaction = 1 THEN SystemValueNameHe COLLATE Hebrew_CI_AS ELSE ActionID COLLATE Hebrew_CI_AS END AS ActionHe
FROM         dbo.RegisterKeys LEFT OUTER JOIN
                      dbo.SystemValues ON CAST(dbo.SystemValues.SystemValueNo AS NVarChar(50)) COLLATE Hebrew_CI_AS = dbo.RegisterKeys.ActionID AND 
                      dbo.SystemValues.SystemTableNo = 50
GO