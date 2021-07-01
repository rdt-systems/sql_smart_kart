CREATE TABLE [dbo].[DiscountTender] (
  [DiscountTenderID] [uniqueidentifier] NOT NULL,
  [DiscountNo] [uniqueidentifier] NULL,
  [TenderNo] [uniqueidentifier] NULL,
  [State] [bit] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([DiscountTenderID])
)
GO