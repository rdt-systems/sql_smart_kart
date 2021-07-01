CREATE TABLE [dbo].[ReturnVenderToPO] (
  [ReturnVenderToPOID] [uniqueidentifier] NOT NULL,
  [ReturnToVenderID] [uniqueidentifier] NULL,
  [PurchaseOrderID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([ReturnVenderToPOID])
)
GO