SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetEncData] as
SELECT     *
FROM         [dbo].[EncData]

WHERE ISNULL(Type,'') <> 'POS'
GO