CREATE TABLE [dbo].[SupplierDivision] (
  [TransactionID] [uniqueidentifier] NOT NULL,
  [ApplyAmount] [money] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([TransactionID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO