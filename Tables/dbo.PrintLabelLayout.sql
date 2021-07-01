CREATE TABLE [dbo].[PrintLabelLayout] (
  [PrintLabelLayoutID] [uniqueidentifier] NOT NULL,
  [LayoutName] [nvarchar](4000) NULL,
  [LayoutContent] [text] NULL,
  [PrinterType] [int] NULL,
  [Status] [int] NULL,
  CONSTRAINT [PK_PrintLabelLayout] PRIMARY KEY CLUSTERED ([PrintLabelLayoutID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO