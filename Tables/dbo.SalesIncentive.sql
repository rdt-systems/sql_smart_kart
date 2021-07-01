CREATE TABLE [dbo].[SalesIncentive] (
  [SalesIncentiveID] [uniqueidentifier] NOT NULL,
  [ItemMainID] [uniqueidentifier] NOT NULL,
  [IncentiveValuePercent] [decimal](18, 3) NULL,
  [IncentiveValueAmount] [money] NULL,
  [FromDate] [datetime] NULL,
  [ToDate] [datetime] NULL,
  [Status] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [SalesIncentiveHeaderID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_SalesIncentive] PRIMARY KEY CLUSTERED ([SalesIncentiveID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

ALTER TABLE [dbo].[SalesIncentive]
  ADD CONSTRAINT [FK_SalesIncentive_IncentiveHeader] FOREIGN KEY ([SalesIncentiveHeaderID]) REFERENCES [dbo].[SalesIncentiveHeader] ([SalesIncentiveHeaderID])
GO