CREATE TABLE [dbo].[Gift] (
  [GiftID] [uniqueidentifier] NOT NULL,
  [GiftNumber] [nvarchar](50) NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [Amount] [money] NULL,
  [GiftType] [int] NULL,
  [GiftDate] [datetime] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([GiftID])
)
GO