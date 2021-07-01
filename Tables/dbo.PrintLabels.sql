CREATE TABLE [dbo].[PrintLabels] (
  [PrintLabelsID] [uniqueidentifier] NOT NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [Tag] [bit] NULL,
  [Status] [char](50) NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [Qty] [int] NULL,
  [StoreID] [uniqueidentifier] NULL,
  CONSTRAINT [PK_PrintLabels] PRIMARY KEY CLUSTERED ([PrintLabelsID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO