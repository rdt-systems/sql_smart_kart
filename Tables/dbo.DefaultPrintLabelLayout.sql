CREATE TABLE [dbo].[DefaultPrintLabelLayout] (
  [PrintLabelLayoutID] [uniqueidentifier] NOT NULL,
  [LayoutName] [nvarchar](4000) NULL,
  [LayoutContent] [text] NULL,
  [PrinterType] [int] NULL,
  CONSTRAINT [PK_DefaultPrintLabelLayout] PRIMARY KEY CLUSTERED ([PrintLabelLayoutID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE UNIQUE INDEX [DefaultPrintLabelLayout_ixU]
  ON [dbo].[DefaultPrintLabelLayout] ([LayoutName])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO