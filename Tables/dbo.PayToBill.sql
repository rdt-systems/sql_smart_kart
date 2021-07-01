CREATE TABLE [dbo].[PayToBill] (
  [PayToBillID] [uniqueidentifier] NOT NULL,
  [SuppTenderID] [uniqueidentifier] NULL,
  [BillID] [uniqueidentifier] NULL,
  [Amount] [money] NULL,
  [Note] [nvarchar](4000) NULL,
  [IsReturn] [bit] NULL CONSTRAINT [DF_PayToBill_IsReturn] DEFAULT (0),
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [QBNumber] [nvarchar](50) NULL,
  CONSTRAINT [PK_PayToBill] PRIMARY KEY CLUSTERED ([PayToBillID])
)
GO