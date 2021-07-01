CREATE TABLE [dbo].[SizeList] (
  [SizeListID] [int] IDENTITY,
  [Value] [nvarchar](1000) NULL,
  [Sort] [smallint] NULL,
  [Status] [smallint] NULL CONSTRAINT [DF_SizeList_Status] DEFAULT (1),
  CONSTRAINT [PK_SizeList] PRIMARY KEY CLUSTERED ([SizeListID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO