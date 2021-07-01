CREATE TABLE [dbo].[SystemValues] (
  [SystemValueNo] [int] NOT NULL,
  [SystemValueName] [nvarchar](50) NULL,
  [SortOrder] [int] NULL,
  [SystemTableNo] [bigint] NOT NULL,
  [SystemValueNameHe] [nvarchar](50) NULL,
  [DateModified] [datetime] NULL,
  CONSTRAINT [PK_SystemValues] PRIMARY KEY CLUSTERED ([SystemValueNo], [SystemTableNo])
)
GO