# DataGrid 由于列名含有特殊字符而无法正常显示数据的解决方案

**本文来源： 
qq_41441897：[WPF DataGrid 列名包含敏感字符的解决方法](https://blog.csdn.net/qq_41441897/article/details/82386243)**

当使用DataGrid进行数据绑定的时候，如果后台绑定的DataTable的列名中含有特殊标点，

例如 **. \ \\ / [ ] ( )** 等
则会导致该列所有数据都无法显示，但确实是有值，可以通过排序发现单元格中值存在

PS：一般是项目需要显示这些字符，比如结果中列得包含单位的时候。

**解决方案：**
给要显示的 `DataTable` 添加 `AutoGeneratingColumn` 事件

``` C#
private void DataGrid_AutoGeneratingColumn(object sender, DataGridAutoGeneratingColumnEventArgs e)
{
    string columnName = e.PropertyName;
    if (e.Column is DataGridBoundColumn &&
      (columnName.Contains(".") ||
       columnName.Contains("\\")||
       columnName.Contains("/") ||
       columnName.Contains("[") ||
       columnName.Contains("]") ||
       columnName.Contains("(") ||
       columnName.Contains(")")))
    {
        DataGridBoundColumn dataGridBoundColumn = e.Column as DataGridBoundColumn;
        dataGridBoundColumn.Binding = new Binding("[" + e.PropertyName + "]");
    }
}
```
