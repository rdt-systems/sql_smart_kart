SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[UsersStoreView]
AS
SELECT     dbo.UsersStore.UserStoreID, dbo.UsersStore.UserID, dbo.UsersStore.OnLine, dbo.UsersStore.StoreID, dbo.UsersStore.IsDefault, dbo.UsersStore.GroupID, 
                      dbo.UsersStore.Manager, dbo.UsersStore.LogonDate, dbo.UsersStore.DateCreated, dbo.UsersStore.UserCreated, dbo.UsersStore.DateModified, 
                      dbo.UsersStore.UserModified, dbo.Users.UserName, ISNULL(dbo.Users.UserLName, '') + ISNULL(',' + dbo.Users.UserFName, '') AS NAME, 
                      dbo.UsersStore.Status
FROM         dbo.UsersStore INNER JOIN
                      dbo.Users ON dbo.UsersStore.UserID = dbo.Users.UserId
WHERE     (dbo.Users.Status > 0)
GO