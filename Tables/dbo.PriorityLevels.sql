CREATE TABLE [dbo].[PriorityLevels] (
  [PriorityID] [int] IDENTITY,
  [StoreID] [uniqueidentifier] NOT NULL,
  [StoreNumber] [nvarchar](40) NOT NULL,
  [Priority] [int] NOT NULL,
  [Status] [int] NOT NULL CONSTRAINT [DF_PriorityLevels_Status] DEFAULT (1),
  [DateModified] [datetime] NULL,
  [StoreName] [nvarchar](100) NULL,
  CONSTRAINT [PK_PriorityLevels] PRIMARY KEY CLUSTERED ([PriorityID])
)
GO