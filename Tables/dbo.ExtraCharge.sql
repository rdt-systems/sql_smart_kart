CREATE TABLE [dbo].[ExtraCharge] (
  [ExtraChargeID] [uniqueidentifier] NOT NULL,
  [ExtraChargeName] [nvarchar](50) NULL,
  [ExtraChargeDescription] [nvarchar](4000) NULL,
  [ExtraChargeType] [int] NOT NULL,
  [ExtraChargeQty] [numeric](18, 2) NULL,
  [IsExtraChargeIncluded] [bit] NULL,
  [ExtraChargeAccount] [uniqueidentifier] NULL,
  [ItemStoreNo] [uniqueidentifier] NOT NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([ExtraChargeID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO