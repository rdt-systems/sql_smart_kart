CREATE TABLE [dbo].[Printed] (
  [PrintedName] [varchar](50) NOT NULL,
  [PrintedContent] [text] NOT NULL,
  [Status] [int] NULL CONSTRAINT [DF_Printed_Status] DEFAULT (1)
)
GO