CREATE TABLE [dbo].[Credit] (
  [CreditID] [uniqueidentifier] NOT NULL,
  [Name] [nvarchar](50) NULL,
  [Description] [nvarchar](4000) NULL,
  [Days] [int] NULL,
  [InterestRate] [numeric](6, 3) NULL,
  [CreditType] [bit] NULL,
  [NetDue] [int] NULL,
  [DayInMonth] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [InterestRate2] [numeric](6, 3) NULL,
  [CreditType2] [bit] NULL,
  PRIMARY KEY CLUSTERED ([CreditID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO