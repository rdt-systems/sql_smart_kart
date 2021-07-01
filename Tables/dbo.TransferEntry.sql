CREATE TABLE [dbo].[TransferEntry] (
  [TransferEntryID] [uniqueidentifier] NOT NULL,
  [TransferID] [uniqueidentifier] NULL,
  [ItemStoreNo] [uniqueidentifier] NULL,
  [Qty] [decimal] NULL,
  [UOMQty] [decimal] NULL,
  [UOMType] [int] NULL,
  [UOMPrice] [money] NULL,
  [LinkNo] [uniqueidentifier] NULL,
  [Note] [nvarchar](4000) NULL,
  [SortOrder] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [Cost] [money] NULL,
  [RequestTransferEntryID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_TransferEntry] PRIMARY KEY CLUSTERED ([TransferEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_QuickReport_4]
  ON [dbo].[TransferEntry] ([Status])
  INCLUDE ([TransferID], [Qty], [UOMType], [UserCreated])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_QuickReport_8]
  ON [dbo].[TransferEntry] ([Status])
  INCLUDE ([TransferID], [ItemStoreNo], [Qty], [UOMType], [UserCreated])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransferEntry_ItemStoreNo_Status]
  ON [dbo].[TransferEntry] ([ItemStoreNo], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransferEntry_PendingOrders_001]
  ON [dbo].[TransferEntry] ([TransferID])
  INCLUDE ([Qty], [Status], [RequestTransferEntryID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransferEntry_Speed_001]
  ON [dbo].[TransferEntry] ([Status])
  INCLUDE ([TransferEntryID], [TransferID], [Qty])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [nci_wi_TransferEntry_0B1]
  ON [dbo].[TransferEntry] ([RequestTransferEntryID], [TransferID])
  INCLUDE ([Qty], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_UpdateRequestStatusFromTransfer] 
   ON  [dbo].[TransferEntry]
   AFTER INSERT,UPDATE
AS 

IF EXISTS (Select 1 from inserted Where RequestTransferEntryID IS NOT NULL)

BEGIN
	SET NOCOUNT ON;
Declare @RequestTransferID Uniqueidentifier
Declare @TransferID Uniqueidentifier
Declare @Status int

Select @RequestTransferID = R.RequestTransferID From RequestTransferEntry R INNER Join inserted I on R.RequestTransferEntryID = I.RequestTransferEntryID 

SELECT @Status = CASE WHEN Transfered > 0 and Requasted > Transfered THEN 1 WHEN Transfered > 0 and Requasted <= Transfered THEN 2 ELSE 0 END From RequestStatusPointView Where RequestTransferID = @RequestTransferID

Update RequestTransfer Set RequestStatus = @Status, DateModified = dbo.GetLocalDate() Where RequestTransferID = @RequestTransferID

END
GO













SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO