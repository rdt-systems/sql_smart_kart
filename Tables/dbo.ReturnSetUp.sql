CREATE TABLE [dbo].[ReturnSetUp] (
  [ReturnSetUpID] [uniqueidentifier] NOT NULL,
  [StoreID] [uniqueidentifier] NULL,
  [DayFerReturn] [int] NULL,
  [Percent] [decimal] NOT NULL,
  [Status] [smallint] NULL,
  [BalanceDoe] [money] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([ReturnSetUpID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO