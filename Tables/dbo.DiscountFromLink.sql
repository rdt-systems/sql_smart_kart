CREATE TABLE [dbo].[DiscountFromLink] (
  [ID] [uniqueidentifier] NOT NULL,
  [LinkID] [uniqueidentifier] NULL,
  [Status] [int] NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateCreated] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([ID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO