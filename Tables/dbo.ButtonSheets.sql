CREATE TABLE [dbo].[ButtonSheets] (
  [SheetID] [uniqueidentifier] NOT NULL,
  [SheetName] [nvarchar](150) NULL,
  [Status] [int] NOT NULL,
  [DateModified] [datetime] NULL,
  [Sort] [int] NOT NULL,
  CONSTRAINT [PK_ButtonSheets] PRIMARY KEY CLUSTERED ([SheetID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO