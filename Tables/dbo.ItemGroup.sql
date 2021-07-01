CREATE TABLE [dbo].[ItemGroup] (
  [ItemGroupID] [uniqueidentifier] NOT NULL,
  [ItemGroupName] [nvarchar](50) NULL,
  [ParentID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_ItemGroup] PRIMARY KEY CLUSTERED ([ItemGroupID])
)
GO