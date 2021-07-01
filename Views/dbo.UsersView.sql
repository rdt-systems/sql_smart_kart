SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[UsersView]
AS
SELECT DISTINCT 
                         Users.UserId, Users.UserName, Users.Password, ISNULL(Users.UserFName,'') AS UserFName, ISNULL(Users.UserLName,'') AS UserLName, Users.Address, Users.HomePhoneNumber, 
						 Users.WorkPhoneNumber, Users.Fax, Users.Email, Users.ZipCode, Users.IsSuperAdmin, 
                         Users.Status, Users.DateCreated, Users.UserCreated, Users.DateModified, Users.UserModified, UsersStore.GroupID, (CASE WHEN dbo.Users.IsSuperAdmin = 1 THEN '1' ELSE dbo.UsersStore.Manager END) AS Manager, 
                         (CASE WHEN dbo.Users.IsSuperAdmin = 1 THEN '0' ELSE dbo.UsersStore.IsDefault END) AS IsDefault, UsersStore.StoreID, UsersStore.DateModified AS UserStoreDateM, Users.ScanID, Groups.GroupName, 
                         Store.StoreName,Users.IsLogIn
FROM            Store INNER JOIN
                         UsersStore ON Store.StoreID = UsersStore.StoreID RIGHT OUTER JOIN
                         Users ON UsersStore.UserID = Users.UserId AND UsersStore.Status > 0 LEFT OUTER JOIN
                         Groups ON UsersStore.GroupID = Groups.GroupID
WHERE        (UsersStore.Status > 0) OR
                         (UsersStore.Status IS NULL) AND (Users.IsSuperAdmin > 0) OR
                         (UsersStore.Status < 0)
GO