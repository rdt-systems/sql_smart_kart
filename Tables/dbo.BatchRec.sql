CREATE TABLE [dbo].[BatchRec] (
  [BatchRecID] [int] IDENTITY,
  [BatchID] [uniqueidentifier] NOT NULL,
  [TenderID] [int] NOT NULL,
  [ExpectedCount] [int] NULL,
  [ExpectedAmount] [money] NULL,
  [TenderName] [nvarchar](50) NULL,
  [PickUpAmount] [money] NULL,
  [PickUpCount] [int] NULL,
  [SortOrder] [int] NULL,
  [Note] [nvarchar](150) NULL,
  CONSTRAINT [PK_BatchRec] PRIMARY KEY CLUSTERED ([BatchRecID])
)
GO