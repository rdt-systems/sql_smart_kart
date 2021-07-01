CREATE TABLE [dbo].[PriceLevel] (
  [PriceLevelID] [uniqueidentifier] NOT NULL,
  [PriceLevelName] [nvarchar](10) NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([PriceLevelID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO