CREATE TABLE [dbo].[Buyers] (
  [BuyerID] [uniqueidentifier] NOT NULL,
  [UserID] [uniqueidentifier] NOT NULL,
  [SupplierID] [uniqueidentifier] NOT NULL,
  [Status] [int] NOT NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_Buyers] PRIMARY KEY CLUSTERED ([BuyerID])
)
GO