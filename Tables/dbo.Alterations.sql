CREATE TABLE [dbo].[Alterations] (
  [AlterationID] [int] IDENTITY,
  [AlterationNo] [nvarchar](20) NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [TransactionEntryID] [uniqueidentifier] NULL,
  [AlterationStatus] [smallint] NULL,
  [AlterationType] [int] NULL,
  [Note] [ntext] NULL,
  [ExpectedDate] [datetime] NULL,
  [ConveyorID] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL
)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_AlterationsStatusChanged] on [dbo].[Alterations]
for  update
as

Declare @OldStatus int
SELECT @OldStatus = AlterationStatus From Deleted

if   Update (AlterationStatus) AND ((select count(0) from inserted WHERE AlterationStatus >2 and AlterationStatus <> @OldStatus) > 0)
  begin
    INSERT INTO [dbo].[AlterationsStatus] ([AlterationID],[Status],[Date],[UserID])

	SELECT AlterationID, AlterationStatus, dbo.GetLocalDATE(), UserModified FROM      inserted
  end
GO