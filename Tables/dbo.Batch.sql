CREATE TABLE [dbo].[Batch] (
  [BatchID] [uniqueidentifier] NOT NULL,
  [BatchNumber] [nvarchar](50) NULL,
  [CashierID] [uniqueidentifier] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [BatchStatus] [int] NULL,
  [RegisterID] [uniqueidentifier] NULL,
  [OpeningDateTime] [datetime] NULL,
  [ClosingDateTime] [datetime] NULL,
  [OpeningAmount] [money] NULL,
  [ClosingAmount] [money] NULL,
  [OpenHunderdBills] [int] NULL,
  [OpenFiftyBills] [int] NULL,
  [OpenTwentyBills] [int] NULL,
  [OpenTenBills] [int] NULL,
  [OpenFiveBills] [int] NULL,
  [OpenSingels] [int] NULL,
  [OpenQuarter] [int] NULL,
  [OpenDimes] [int] NULL,
  [OpenNickels] [int] NULL,
  [OpenPennies] [int] NULL,
  [OpenOther] [decimal] NULL,
  [CloseHunderdBills] [int] NULL,
  [CloseFiftyBills] [int] NULL,
  [CloseTwentyBills] [int] NULL,
  [CloseTenBills] [int] NULL,
  [CloseFiveBills] [int] NULL,
  [CloseSingels] [int] NULL,
  [CloseQuarter] [int] NULL,
  [CloseDimes] [int] NULL,
  [CloseNickels] [int] NULL,
  [ClosePennies] [int] NULL,
  [CloseOther] [decimal] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [BatchText] [ntext] NULL,
  CONSTRAINT [PK_Batch] PRIMARY KEY CLUSTERED ([BatchID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [IX_Batch_BatchNumber]
  ON [dbo].[Batch] ([BatchNumber])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Batch_CashierID_BatchStatus]
  ON [dbo].[Batch] ([CashierID], [BatchStatus])
  INCLUDE ([BatchNumber], [RegisterID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Batch_CashierID_BatchStatus_OpeningDateTime]
  ON [dbo].[Batch] ([CashierID], [BatchStatus], [OpeningDateTime])
  INCLUDE ([BatchNumber], [RegisterID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [BatchRecUpdate]
   ON  [dbo].[Batch]
   AFTER INSERT , UPDATE
AS 

	SET NOCOUNT ON;
	
--IF
--BEGIN
--If 
--BEGIN
--if UPDATE(BatchStatus) and (select batchstatus from inserted) = 2 and (select batchstatus from deleted) <> 2

--BEGIN
-- Insert Into BatchRec (ExpectedAmount, BatchID ,TenderID , SortOrder,  TenderName , ExpectedCount , PickUpAmount , PickUpCount)
	
--SELECT     tendertotals.Amount, tendertotals.BatchID, dbo.Tender.TenderID, dbo.Tender.SortOrder, dbo.Tender.TenderName, 
--                     tendertotals.Count, 0,0
--    FROM         dbo.Tender INNER JOIN
--                         (SELECT     dbo.TenderEntry.TenderID AS Tender, SUM(dbo.TenderEntry.Amount) AS Amount, COUNT(dbo.TenderEntry.Amount) AS Count, 
--                                                  dbo.[Transaction].BatchID
--                          FROM          dbo.TenderEntry INNER JOIN
--                                                  dbo.Tender AS Tender_1 ON dbo.TenderEntry.TenderID = Tender_1.TenderID INNER JOIN
--                                                  dbo.[Transaction] ON dbo.TenderEntry.TransactionID = dbo.[Transaction].TransactionID
--                                                 inner join inserted on [Transaction].BatchID = inserted.BatchID
--                           GROUP BY dbo.[Transaction].BatchID, dbo.TenderEntry.TenderID) AS tendertotals ON tendertotals.Tender = dbo.Tender.TenderID
                            
--END
GO







SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO