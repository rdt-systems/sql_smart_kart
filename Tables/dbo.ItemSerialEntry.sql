CREATE TABLE [dbo].[ItemSerialEntry] (
  [ItemSerialEntryID] [uniqueidentifier] NOT NULL,
  [TransEntryID] [uniqueidentifier] NULL,
  [SerialNumber1] [nvarchar](50) NULL,
  [SerialNumber2] [nvarchar](50) NULL,
  [SerialNumber3] [nvarchar](50) NULL,
  [SerialNumber4] [nvarchar](50) NULL,
  [SerialNumber5] [nvarchar](50) NULL,
  CONSTRAINT [PK_ItemSerialEntry] PRIMARY KEY CLUSTERED ([ItemSerialEntryID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO