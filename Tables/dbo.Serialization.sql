CREATE TABLE [dbo].[Serialization] (
  [SerializationID] [uniqueidentifier] NOT NULL,
  [ItemNo] [uniqueidentifier] NOT NULL,
  [Barcode] [nvarchar](50) NOT NULL,
  [Status] [smallint] NULL,
  PRIMARY KEY CLUSTERED ([SerializationID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO