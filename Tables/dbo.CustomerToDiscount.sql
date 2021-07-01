CREATE TABLE [dbo].[CustomerToDiscount] (
  [CustumerToDiscountID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_CustomerToDiscount] PRIMARY KEY CLUSTERED ([CustumerToDiscountID])
)
GO