CREATE TABLE [dbo].[DateScopes] (
  [ScopeID] [int] IDENTITY,
  [Description] [nvarchar](50) NULL,
  [FromDate] [datetime] NULL,
  [ToDate] [datetime] NULL,
  [Status] [int] NULL,
  [SortOrder] [int] NULL,
  [UserID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_DateScopes] PRIMARY KEY CLUSTERED ([ScopeID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO