CREATE TABLE [dbo].[ReceiveTransfer] (
  [ReceiveTransferID] [uniqueidentifier] NOT NULL,
  [ReceiveDate] [datetime] NULL,
  [ReciveNo] [nvarchar](20) NULL,
  [StoreID] [uniqueidentifier] NULL,
  [TransferID] [uniqueidentifier] NULL,
  [DateCreate] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [UserCreate] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [Status] [int] NULL,
  CONSTRAINT [PK_ReceiveTransfer] PRIMARY KEY CLUSTERED ([ReceiveTransferID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO