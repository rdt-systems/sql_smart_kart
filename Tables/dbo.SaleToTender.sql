CREATE TABLE [dbo].[SaleToTender] (
  [SaleToTenderID] [uniqueidentifier] NOT NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [SaleID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [TenderID] [int] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_SaleToTender] PRIMARY KEY CLUSTERED ([SaleToTenderID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO