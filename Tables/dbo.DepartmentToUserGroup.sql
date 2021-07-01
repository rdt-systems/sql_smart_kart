CREATE TABLE [dbo].[DepartmentToUserGroup] (
  [DepartmentToUserGroupID] [uniqueidentifier] NOT NULL,
  [GroupID] [uniqueidentifier] NOT NULL,
  [DepartmentID] [uniqueidentifier] NOT NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_DepartmentToUserGroup] PRIMARY KEY CLUSTERED ([DepartmentToUserGroupID])
)
GO