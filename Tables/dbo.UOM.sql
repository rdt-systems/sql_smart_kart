CREATE TABLE [dbo].[UOM] (
  [UOMID] [uniqueidentifier] NOT NULL,
  [UOMName] [nvarchar](50) NULL,
  [SortValue] [smallint] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  PRIMARY KEY CLUSTERED ([UOMID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO