SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemsForWeb]
AS
SELECT     i.BarcodeNumber AS sku, '' AS _store, 'Default' AS _attribute_set, 'simple' AS _type, dbo.InitCap(iv.MainDepartment + COALESCE ('/' + iv.SubDepartment, '') 
                      + COALESCE ('/' + iv.SubSubDepartment, '') + CASE WHEN (COALESCE (iv.Department, '') <> COALESCE (iv.SubSubDepartment, '') AND (COALESCE (iv.Department, '') 
                      <> COALESCE (iv.SubDepartment, ''))) THEN ISNULL('/' + iv.Department, '') ELSE '' END) AS _category, 'Default Category' AS _root_category, 
                      'base' AS _product_websites, iv.Cost AS cost, i.DateCreated AS created_at, COALESCE (REPLACE(REPLACE(cast(i.ExtraInfo2 as nvarchar(MAX)), CHAR(13), '<br>'), CHAR(10), ''), '-') 
                      AS description, iv.Brand AS manufacturer, i.Name AS name, iv.Price AS price, CASE WHEN (cast(i.ExtraInfo as nvarchar(MAX)) = '') THEN '-' ELSE COALESCE (REPLACE(REPLACE(cast(i.ExtraInfo as nvarchar(MAX)), 
                      CHAR(13), '<br>'), CHAR(10), ''), '-') END AS short_description, '1' AS status, '2' AS tax_class_id, '4' AS visibility, i.StyleNo AS weight, iv.OnHand AS qty, '0' AS min_qty, 
                      '1' AS use_config_min_qty, '0' AS is_qty_decimal, '0' AS backorders, '1' AS use_config_backorders, '1' AS min_sale_qty, '1' AS use_config_min_sale_qty, 
                      '0' AS max_sale_qty, '1' AS use_config_max_sale_qty, '1' AS is_in_stock, '1' AS notify_stock_qty, '0' AS use_config_notify_stock_qty, '1' AS manage_stock, 
                      '0' AS use_config_manage_stock, '1' AS stock_status_changed_auto, '0' AS use_config_qty_increments, '1' AS qty_incrementsuse_config_enable_qty_inc, 
                      '0' AS enable_qty_increments, '88' AS is_decimal_divided, '88' AS _media_attribute_id, i.ModalNumber + '.jpg' AS _media_lable, 
                      i.ModalNumber + '.jpg' AS _media_image, i.ModalNumber + '.jpg' AS image, i.ModalNumber + '.jpg' AS small_image, i.ModalNumber + '.jpg' AS thumbnail
FROM         ItemMainAndStoreView AS iv INNER JOIN
                      ItemMain AS i ON i.ItemID = iv.ItemID
WHERE     (iv.Groups IS NOT NULL) AND (iv.ItemStoreID IN
                          (SELECT     ItemStoreID
                            FROM          ItemToGroup
                            WHERE      (Status > 0) AND (ItemGroupID = '25B51D9A-2112-4604-BE3F-0520E5AA0590'))) AND (iv.StoreNo = 'CCB6703D-80CA-41BB-8D13-F338F4D1E503')
GO