CREATE TABLE [dbo].[TransferItems] (
  [TransferID] [uniqueidentifier] NOT NULL,
  [TransferNo] [nvarchar](50) NULL,
  [FromStoreID] [uniqueidentifier] NULL,
  [ToStoreID] [uniqueidentifier] NULL,
  [TransferDate] [datetime] NULL,
  [Note] [nvarchar](4000) NULL,
  [PersonID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [TransferStatus] [int] NULL,
  [Emailed] [bit] NULL,
  CONSTRAINT [PK_TransferItems] PRIMARY KEY CLUSTERED ([TransferID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO