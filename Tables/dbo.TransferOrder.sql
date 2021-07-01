CREATE TABLE [dbo].[TransferOrder] (
  [TransferOrderID] [uniqueidentifier] NOT NULL,
  [TransferOrderNo] [nvarchar](50) NULL,
  [FromStoreID] [uniqueidentifier] NULL,
  [ToStoreID] [uniqueidentifier] NULL,
  [TransferOrderDate] [datetime] NULL,
  [Note] [nvarchar](4000) NULL,
  [OrderStatus] [int] NULL,
  [PersonID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([TransferOrderID])
)
GO