CREATE TABLE [dbo].[TxtHistory] (
  [ID] [int] IDENTITY,
  [Txt] [nvarchar](160) NULL,
  [Reply] [nvarchar](160) NULL,
  [DateReceived] [datetime] NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [IsError] [bit] NULL CONSTRAINT [DF_TxtHistory_IsError] DEFAULT ('false'),
  [RequestType] [int] NULL,
  [FromNumber] [nvarchar](50) NULL,
  [ReplyDate] [datetime] NULL,
  CONSTRAINT [PK_TxtHistory] PRIMARY KEY CLUSTERED ([ID])
)
GO