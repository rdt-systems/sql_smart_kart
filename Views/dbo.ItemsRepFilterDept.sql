SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




create view [dbo].[ItemsRepFilterDept]

as
Select ItemStoreID , departmentid,DS.name
				 -- Into #ItemSelect 
                  
			FROM           ItemsRepFilter irf
							  left outer join DBO.DepartmentStore ds on irf.departmentid = ds.DepartmentStoreID
GO