CREATE TABLE [dbo].[FilterList] (
  [FilterId] [uniqueidentifier] NOT NULL,
  [UserId] [uniqueidentifier] NULL,
  [FilterName] [nvarchar](50) NULL,
  [FilterValue] [nvarchar](500) NULL,
  [FIlter_Type] [nvarchar](50) NULL,
  CONSTRAINT [PK_FilterList] PRIMARY KEY CLUSTERED ([FilterId]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO