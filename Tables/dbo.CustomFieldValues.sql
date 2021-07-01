CREATE TABLE [dbo].[CustomFieldValues] (
  [CustomFieldValueID] [uniqueidentifier] NOT NULL,
  [CustomFieldNo] [uniqueidentifier] NOT NULL,
  [RowNo] [uniqueidentifier] NOT NULL,
  [FieldValue] [nvarchar](4000) NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([CustomFieldValueID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO