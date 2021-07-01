CREATE TABLE [dbo].[Accounts] (
  [AccountID] [uniqueidentifier] NOT NULL,
  [AccountName] [nvarchar](50) NULL,
  [Status] [smallint] NULL CONSTRAINT [DF_Accounts_Status] DEFAULT (5),
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [AccountDescription] [nvarchar](4000) NULL,
  [test] [int] NULL,
  [Test123] [nchar](10) NULL,
  [TetsUnick] [nvarchar](50) NULL,
  CONSTRAINT [PK_Accounts] PRIMARY KEY CLUSTERED ([AccountID])
)
GO

CREATE UNIQUE INDEX [UniqueExceptNulls]
  ON [dbo].[Accounts] ([TetsUnick])
  WHERE ([TetsUnick] IS NOT NULL)
GO