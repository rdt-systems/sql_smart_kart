CREATE TABLE [dbo].[MatrixValues] (
  [MatrixValueID] [uniqueidentifier] NOT NULL,
  [MatrixColumnNo] [uniqueidentifier] NOT NULL,
  [DisplayValue] [nvarchar](50) NOT NULL,
  [SortValue] [int] NULL,
  [Status] [smallint] NULL,
  [Code] [nvarchar](25) NULL,
  CONSTRAINT [PK_MatrixValues] PRIMARY KEY CLUSTERED ([MatrixValueID]) WITH (STATISTICS_NORECOMPUTE = ON),
  CONSTRAINT [CK_DisplayValue] CHECK ([DisplayValue]<>N'')
)
GO

ALTER TABLE [dbo].[MatrixValues]
  ADD CONSTRAINT [FK_MatrixValues_MatrixColumn] FOREIGN KEY ([MatrixColumnNo]) REFERENCES [dbo].[MatrixColumn] ([MatrixColumnID])
GO