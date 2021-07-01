CREATE TABLE [dbo].[LoyaltySetup] (
  [Amount] [money] NULL,
  [DateModified] [datetime] NULL,
  [DayOfWeek] [int] NULL,
  [FromTime] [datetime] NULL,
  [LoyaltySetupID] [uniqueidentifier] NOT NULL,
  [Point] [decimal](18, 2) NULL,
  [Status] [int] NULL,
  [ToTime] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [MemberType] [smallint] NULL
)
GO