CREATE TABLE [dbo].[MatrixColors] (
  [DisplayValue] [nvarchar](200) NOT NULL,
  [SortValue] [int] NULL,
  [Status] [smallint] NULL,
  [Code] [nvarchar](25) NULL,
  CONSTRAINT [PK_MatrixColors] PRIMARY KEY CLUSTERED ([DisplayValue])
)
GO