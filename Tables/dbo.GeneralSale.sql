CREATE TABLE [dbo].[GeneralSale] (
  [GeneralSaleID] [uniqueidentifier] NOT NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_GeneralSale] PRIMARY KEY CLUSTERED ([GeneralSaleID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO