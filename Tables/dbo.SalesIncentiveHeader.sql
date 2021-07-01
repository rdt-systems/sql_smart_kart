CREATE TABLE [dbo].[SalesIncentiveHeader] (
  [SalesIncentiveHeaderID] [uniqueidentifier] NOT NULL,
  [Name] [nvarchar](50) NULL,
  [FromDate] [datetime] NULL,
  [ToDate] [datetime] NULL,
  [IncentiveAmount] [money] NULL,
  [IncentivePercent] [decimal](18, 2) NULL,
  [Status] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_SalesIncentiveHeader] PRIMARY KEY CLUSTERED ([SalesIncentiveHeaderID])
)
GO