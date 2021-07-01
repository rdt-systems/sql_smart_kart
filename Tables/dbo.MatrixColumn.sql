CREATE TABLE [dbo].[MatrixColumn] (
  [MatrixColumnID] [uniqueidentifier] NOT NULL,
  [MatrixNo] [uniqueidentifier] NOT NULL,
  [ColumnName] [nvarchar](50) NOT NULL,
  [SortOrder] [int] NULL,
  [Status] [smallint] NULL,
  CONSTRAINT [PK_MatrixColumn] PRIMARY KEY CLUSTERED ([MatrixColumnID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

ALTER TABLE [dbo].[MatrixColumn]
  ADD CONSTRAINT [FK_MatrixColumn_MatrixTable] FOREIGN KEY ([MatrixNo]) REFERENCES [dbo].[MatrixTable] ([MatrixTableID])
GO