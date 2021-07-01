CREATE TABLE [dbo].[MatrixValuesBKP] (
  [MatrixValueID] [uniqueidentifier] NOT NULL,
  [MatrixColumnNo] [uniqueidentifier] NOT NULL,
  [DisplayValue] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
  [SortValue] [int] NULL,
  [Status] [smallint] NULL,
  [Code] [nvarchar](25) NULL,
  PRIMARY KEY CLUSTERED ([MatrixValueID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO