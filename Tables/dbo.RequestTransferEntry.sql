CREATE TABLE [dbo].[RequestTransferEntry] (
  [RequestTransferEntryID] [uniqueidentifier] NOT NULL,
  [RequestTransferID] [uniqueidentifier] NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [Qty] [decimal] NULL,
  [UOMQty] [decimal](18, 2) NULL,
  [UOMType] [int] NULL,
  [Note] [nvarchar](4000) NULL,
  [SortOrder] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [Status] [int] NULL,
  [Cost] [decimal] NULL,
  [CustomerId] [uniqueidentifier] NULL,
  [ItemId] [uniqueidentifier] NULL,
  [TransactionEntryID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_RequestTransferEntry] PRIMARY KEY CLUSTERED ([RequestTransferEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_RequestTransferEntry_Fulfill_Speed_001]
  ON [dbo].[RequestTransferEntry] ([Status])
  INCLUDE ([RequestTransferID], [ItemId])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_RequestTransferEntry_ItemsQuery_Speed_003]
  ON [dbo].[RequestTransferEntry] ([Status])
  INCLUDE ([RequestTransferID], [Qty], [DateModified], [ItemId])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_RequestTransferEntry_Text_Speed_0001]
  ON [dbo].[RequestTransferEntry] ([Status])
  INCLUDE ([RequestTransferID], [ItemStoreID], [Qty], [CustomerId], [TransactionEntryID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_RequestTransferEntry_Text_Speed_0002]
  ON [dbo].[RequestTransferEntry] ([TransactionEntryID], [Status])
  INCLUDE ([RequestTransferID], [ItemStoreID], [Qty], [CustomerId])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_RequestTransferEntry_View_Speed_00001]
  ON [dbo].[RequestTransferEntry] ([Status])
  INCLUDE ([RequestTransferID], [Qty], [UOMQty])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [nci_wi_RequestTransferEntry_2CBB56F8F2E15AA3A651F07411B9DFA8]
  ON [dbo].[RequestTransferEntry] ([RequestTransferID], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_RequestTransferEntry_Delete_Request_AndTransfer]
   ON  [dbo].[RequestTransferEntry] 
   AFTER UPDATE
AS 

IF UPDATE(Status)
BEGIN
SET NOCOUNT ON;
Declare @OldStatus Int, @NewStatus Int
Select @OldStatus = Status from deleted
Select @NewStatus = Status from inserted
IF @NewStatus <> @OldStatus AND @NewStatus < 1
BEGIN
DECLARE @RequestTransferEntryID uniqueidentifier
SELECT @RequestTransferEntryID = RequestTransferEntryID from inserted
Update TransferEntry Set Status = @NewStatus, DateModified = dbo.GetLocalDate() 
from TransferEntry T LEFT OUTER JOIN ReceiveTransferEntry E ON T.TransferEntryID = E.TransferEntryID
Where ISNULL(E.Status,0) < =0 and T.RequestTransferEntryID = @RequestTransferEntryID 
Update RequestTransfer Set Status = -1, DateModified = dbo.GetLocalDate() 
Where Status >0 AND NOT EXISTS (Select 1 From RequestTransferEntry 
Where RequestTransferID = RequestTransfer.RequestTransferID And Status > 0)
Update TransferItems Set Status = -1, DateModified = dbo.GetLocalDate() 
Where Status >0 AND NOT EXISTS (Select 1 From TransferEntry 
Where TransferID = TransferItems.TransferID And Status > 0)
END
END
GO













SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO