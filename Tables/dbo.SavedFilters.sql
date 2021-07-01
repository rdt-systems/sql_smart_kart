CREATE TABLE [dbo].[SavedFilters] (
  [FilterID] [uniqueidentifier] NOT NULL,
  [FilterName] [nvarchar](50) NULL,
  [FilterValue] [nvarchar](4000) NULL,
  [Category] [int] NULL,
  [HasItem] [bit] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([FilterID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO