SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_GetSalesProfit]  
(@Filter nvarchar(max),  
@CustomerFilter nvarchar(max))  
as  
  
declare @MyWhere nvarchar(max)  
  
if @CustomerFilter<>''  
 begin   
  declare @CustomerSelect nvarchar(max)  
  Set  @CustomerSelect=' Select CustomerID   
          Into #CustomerSelect   
         From CustomerRepFilter   
         Where (1=1) '  
  SET @MyWhere= ' and exists (Select 1 From #CustomerSelect where CustomerID=SalesProfitView.CustomerID ) '  
 end   
   
declare @MySelect nvarchar(max)  
set @MySelect= 'SELECT   *  
  FROM dbo.SalesProfitView  
  WHERE  1=1  '  
print @MySelect  
print @Filter   
print @MyWhere  
Execute (@CustomerSelect+@CustomerFilter+@MySelect + @Filter+@MyWhere )
GO