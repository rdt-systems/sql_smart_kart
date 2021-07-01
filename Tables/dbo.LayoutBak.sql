CREATE TABLE [dbo].[LayoutBak] (
  [LayoutName] [nvarchar](50) NULL,
  [LayoutFileName] [nvarchar](50) NULL,
  [LayoutXMLContent] [ntext] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateCreated] [datetime] NULL,
  [ComputerName] [nvarchar](150) NULL
)
GO