CREATE TABLE [dbo].[TenderToDiscount] (
  [TenderToDiscountID] [uniqueidentifier] NOT NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [TenderID] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_TenderToDiscount] PRIMARY KEY CLUSTERED ([TenderToDiscountID])
)
GO