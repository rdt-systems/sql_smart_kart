CREATE TABLE [dbo].[TransReturen] (
  [ReturenID] [int] NOT NULL,
  [SaleTransEntryID] [uniqueidentifier] NULL,
  [Qty] [float] NULL,
  [ReturenTransID] [uniqueidentifier] NULL,
  [DateCreated] [datetime] NULL,
  [Status] [int] NULL,
  CONSTRAINT [PK_TransReturen] PRIMARY KEY CLUSTERED ([ReturenID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_ReturnQtyView_1]
  ON [dbo].[TransReturen] ([Status])
  INCLUDE ([Qty], [ReturenTransID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_TransReturn_Dashboard01]
  ON [dbo].[TransReturen] ([ReturenTransID])
  INCLUDE ([SaleTransEntryID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [TransReturn_Return_001]
  ON [dbo].[TransReturen] ([Status])
  INCLUDE ([SaleTransEntryID], [Qty], [ReturenTransID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [TransReturn_Return_002]
  ON [dbo].[TransReturen] ([SaleTransEntryID], [Status])
  INCLUDE ([Qty], [ReturenTransID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_TransReturen_DelTransferRequest] 
   ON  [dbo].[TransReturen] 
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	Declare @TransactionEntryID Uniqueidentifier
	SELECT @TransactionEntryID = ReturenTransID from inserted
	IF @TransactionEntryID IS NOT NULL
	BEGIN

	Update RequestTransferEntry Set Status = -1, DateModified = dbo.GetLocalDate() 
	from RequestTransferEntry R LEFT OUTER JOIN TransferEntry T ON R.RequestTransferEntryID = T.RequestTransferEntryID 
	LEFT OUTER JOIN ReceiveTransferEntry E ON T.TransferEntryID = E.TransferEntryID
    Where ISNULL(E.Status,0) < =0 and R.TransactionEntryID = @TransactionEntryID 
	Update TransactionEntry Set TransactionEntryType = 0, DateModified = dbo.GetLocalDate() WHere TransactionEntryID = @TransactionEntryID AND TransactionEntryType = 11
	
	END


END
GO









SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO