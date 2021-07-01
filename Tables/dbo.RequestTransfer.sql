CREATE TABLE [dbo].[RequestTransfer] (
  [RequestTransferID] [uniqueidentifier] NOT NULL,
  [RequestDate] [datetime] NULL,
  [RequestNo] [nvarchar](20) NULL,
  [FromStoreID] [uniqueidentifier] NULL,
  [ToStoreID] [uniqueidentifier] NULL,
  [Note] [nvarchar](4000) NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [Status] [int] NULL,
  [RequestStatus] [int] NOT NULL CONSTRAINT [DF_RequestTransfer_RequastStatus] DEFAULT (1),
  [Emailed] [bit] NULL,
  CONSTRAINT [PK_RequestTransfer] PRIMARY KEY CLUSTERED ([RequestTransferID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_RequestTransfer_ItemsQuery_Speed_003]
  ON [dbo].[RequestTransfer] ([Status], [RequestStatus])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO