CREATE TABLE [dbo].[CustomFields] (
  [CustomFieldID] [uniqueidentifier] NOT NULL,
  [CustomFieldName] [varchar](50) NULL,
  [CustomFieldType] [varchar](50) NULL,
  [LinkToTable] [varchar](50) NULL,
  [SortOrder] [smallint] NULL,
  PRIMARY KEY CLUSTERED ([CustomFieldID])
)
GO