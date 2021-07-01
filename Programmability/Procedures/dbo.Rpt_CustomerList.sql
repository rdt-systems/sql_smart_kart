SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Rpt_CustomerList] AS

select * from CustomerWithAddressView
Where status>0
GO