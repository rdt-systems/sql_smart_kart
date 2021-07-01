CREATE TABLE [dbo].[testTable] (
  [ItemID] [uniqueidentifier] NOT NULL,
  [DateCreated] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([ItemID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO