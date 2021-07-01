CREATE TABLE [dbo].[CommissionDetails] (
  [CommissionDetailsID] [uniqueidentifier] NOT NULL,
  [CommissionID] [uniqueidentifier] NOT NULL,
  [TransactionID] [uniqueidentifier] NOT NULL,
  [Amount] [money] NULL,
  [Commission] [money] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([CommissionDetailsID])
)
GO