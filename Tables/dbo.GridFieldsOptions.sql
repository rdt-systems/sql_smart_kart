CREATE TABLE [dbo].[GridFieldsOptions] (
  [ID] [int] IDENTITY,
  [ViewName] [nvarchar](25) NULL,
  [ViewDescription] [nvarchar](50) NULL,
  [ShowField] [bit] NULL,
  [FieldName] [nvarchar](25) NULL,
  [FieldDescription] [nvarchar](50) NULL,
  [SQLField] [nvarchar](4000) NULL,
  [TableName] [nvarchar](50) NULL,
  [SQLFieldAS] [nvarchar](4000) NULL,
  [SQLFrom] [nvarchar](4000) NULL,
  [EnumModuleName] [nvarchar](50) NULL,
  [ShowRow] [bit] NULL,
  [FieldType] [nvarchar](50) NULL
)
GO