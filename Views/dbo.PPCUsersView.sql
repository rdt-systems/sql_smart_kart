SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PPCUsersView]
AS
SELECT     dbo.PPCUsers.PPCUserID, dbo.PPCUsers.UserName, dbo.PPCUsers.Password, dbo.PPCUsers.AssociatedUserID, dbo.PPCUsers.AssociatedResellerID, dbo.PPCUsers.Type, dbo.PPCUsers.Status, 
                      dbo.PPCUsers.DateCreated, dbo.PPCUsers.UserCreated, dbo.PPCUsers.DateModified, dbo.PPCUsers.UserModified, 
                      dbo.SysPCUserType.SystemValueName AS UserType
FROM         dbo.PPCUsers INNER JOIN
                      dbo.SysPCUserType ON dbo.PPCUsers.Type = dbo.SysPCUserType.SystemValueNo
GO