CREATE TABLE [dbo].[Manufacturers] (
  [ManufacturerID] [uniqueidentifier] NOT NULL,
  [ManufacturerName] [nvarchar](50) NOT NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [ManufacturerNo] [nvarchar](50) NULL,
  CONSTRAINT [PK_Manufacturers] PRIMARY KEY CLUSTERED ([ManufacturerID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_Manufacturers_6_1394104007__K1_2]
  ON [dbo].[Manufacturers] ([ManufacturerID])
  INCLUDE ([ManufacturerName])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Manufacturers_Status]
  ON [dbo].[Manufacturers] ([Status])
  INCLUDE ([DateCreated], [DateModified], [ManufacturerName], [UserCreated], [UserModified])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Manufacturers_Status_DateModified]
  ON [dbo].[Manufacturers] ([Status], [DateModified])
  INCLUDE ([DateCreated], [ManufacturerName], [UserCreated], [UserModified])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO