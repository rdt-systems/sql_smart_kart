CREATE TABLE [dbo].[SQLImportLog] (
  [id] [bigint] IDENTITY,
  [filename] [nvarchar](100) NOT NULL,
  [query] [text] NULL,
  [errors] [text] NULL,
  [time] [datetime] NOT NULL,
  [result] [tinyint] NULL,
  CONSTRAINT [PK_SQLImportLog] PRIMARY KEY CLUSTERED ([id])
)
GO