CREATE TABLE [dbo].[ReceiveToPO] (
  [ReceiveToPOID] [uniqueidentifier] NOT NULL,
  [ReceiveID] [uniqueidentifier] NULL,
  [POID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([ReceiveToPOID])
)
GO