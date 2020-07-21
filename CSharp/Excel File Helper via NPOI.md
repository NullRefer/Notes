# C#中 `DataTable` 与 Excel 相互转换

```c#
    /// <summary>
    /// Excel小帮手
    /// </summary>
    public static class ExcelHelper
    {
        /// <summary>
        /// 读取Excel转化为DataTable
        /// </summary>
        /// <param name="fileName">Excel文件路径</param>
        /// <param name="sheetName">Excel SheetName</param>
        /// <param name="sheetIndex"></param>
        /// <returns></returns>
        /// <exception cref="Exception">当sheetName或sheetIndex不存在对应表时</exception>
        public static DataTable ExcelToDataTable(string fileName = null, string sheetName = null, int sheetIndex = 0)
        {
            if (string.IsNullOrEmpty(fileName))
            {
                using var ofd = new OpenFileDialog
                {
                    Filter = "Excel 2007-13文件(*.xlsx)|*.xlsx|Excel 2003文件(*.xls)|*.xls",
                    DefaultExt = "xlsx",
                    AddExtension = true
                };
                if (ofd.ShowDialog() == DialogResult.OK)
                {
                    fileName = ofd.FileName;
                }
                else { return null; }
            }
            IWorkbook workbook = null;
            using var fs = File.OpenRead(fileName);
            if (Path.GetExtension(fileName) == ".xls")
            {
                workbook = new HSSFWorkbook(fs);
            }
            else if (Path.GetExtension(fileName) == ".xlsx")
            {
                workbook = new XSSFWorkbook(fs);
            }
            if (workbook == null)
            {
                return null;
            }
            if (!string.IsNullOrEmpty(sheetName))
            {
                var sheet = workbook.GetSheet(sheetName);
                if (sheet == null)
                {
                    throw new Exception($"Excel表中不存在表名{sheetName}");
                }
                return SheetToDataTable(sheet);
            }
            else
            {
                var sheet = workbook.GetSheetAt(sheetIndex);
                if (sheet == null)
                {
                    throw new Exception($"Excel表中不存在表名{sheetName}");
                }
                return SheetToDataTable(sheet);
            }
        }

        /// <summary>
        /// 读取多表型Excel转化为DataSet
        /// </summary>
        /// <param name="fileName">Excel文件路径</param>
        /// <returns></returns>
        public static DataSet ExcelToDataSet(string fileName = null)
        {
            if (string.IsNullOrEmpty(fileName))
            {
                using var ofd = new OpenFileDialog
                {
                    Filter = "Excel 2007-13文件(*.xlsx)|*.xlsx|Excel 2003文件(*.xls)|*.xls",
                    DefaultExt = "xlsx",
                    AddExtension = true
                };
                if (ofd.ShowDialog() == DialogResult.OK)
                {
                    fileName = ofd.FileName;
                }
                else { return null; }
            }
            IWorkbook workbook = null;
            using var fs = File.OpenRead(fileName);
            if (Path.GetExtension(fileName) == ".xls")
            {
                workbook = new HSSFWorkbook(fs);
            }
            else if (Path.GetExtension(fileName) == ".xlsx")
            {
                workbook = new XSSFWorkbook(fs);
            }
            if (workbook == null)
            {
                return null;
            }
            DataSet ds = new DataSet();
            for (int i = 0; i < workbook.NumberOfSheets; i++)
            {
                var sheet = workbook.GetSheetAt(i);
                ds.Tables.Add(SheetToDataTable(sheet));
            }
            return ds;
        }

        /// <summary>
        /// Datable导出成Excel
        /// </summary>
        /// <param name="dt">需要导出的datatable</param>
        /// <param name="fileName">excel文件路径</param>
        /// <param name="isShowResult">是否显示导出完成对话框</param>
        public static void DataTableToExcel(DataTable dt = null, string fileName = null, bool isShowResult = true)
        {
            if (string.IsNullOrEmpty(fileName))
            {
                using var sfd = new SaveFileDialog
                {
                    Filter = "Excel 2007-13文件(*.xlsx)|*.xlsx|Excel 2003文件(*.xls)|*.xls",
                    DefaultExt = "xlsx",
                    AddExtension = true
                };
                if (sfd.ShowDialog() == DialogResult.OK)
                {
                    fileName = sfd.FileName;
                }
                else { return; }
            }
            if (dt == null)
            {
                throw new ArgumentNullException(nameof(dt));
            }
            IWorkbook workbook = new XSSFWorkbook();
            string fileExt = Path.GetExtension(fileName);
            if (fileExt == ".xls")
            {
                workbook = new HSSFWorkbook();
            }
            ISheet sheet = string.IsNullOrEmpty(dt.TableName) ? workbook.CreateSheet("Sheet1") : workbook.CreateSheet(dt.TableName);
            DataTableToSheet(ref sheet, dt);
            using var stream = new MemoryStream();
            workbook.Write(stream);
            var buf = stream.ToArray();
            //保存为Excel文件  
            using FileStream fs = new FileStream(fileName, FileMode.Create, FileAccess.Write);
            fs.Write(buf, 0, buf.Length);
            fs.Flush();
            if (isShowResult)
            {
                System.Windows.MessageBox.Show("保存成功!");
            }
        }

        /// <summary>
        /// 将DataSet导出成多Sheet型Excel
        /// </summary>
        /// <param name="ds"></param>
        /// <param name="fileName">Excel文件路径</param>
        /// <param name="isShowResult">是否显示导出完成对话框</param>
        public static void DataSetToExcel(DataSet ds = null, string fileName = null, bool isShowResult = true)
        {
            if (string.IsNullOrEmpty(fileName))
            {
                using var sfd = new SaveFileDialog
                {
                    Filter = "Excel 2007-13文件(*.xlsx)|*.xlsx|Excel 2003文件(*.xls)|*.xls",
                    DefaultExt = "xlsx",
                    AddExtension = true
                };
                if (sfd.ShowDialog() == DialogResult.OK)
                {
                    fileName = sfd.FileName;
                }
                else { return; }
            }
            if (ds == null)
            {
                throw new ArgumentNullException(nameof(ds));
            }
            IWorkbook workbook = new XSSFWorkbook();
            string fileExt = Path.GetExtension(fileName);
            if (fileExt == ".xls")
            {
                workbook = new HSSFWorkbook();
            }
            foreach (DataTable dt in ds.Tables)
            {
                ISheet sheet = string.IsNullOrEmpty(dt.TableName) ? workbook.CreateSheet("Sheet1") : workbook.CreateSheet(dt.TableName);
                DataTableToSheet(ref sheet, dt);
            }
            using var stream = new MemoryStream();
            workbook.Write(stream);
            var buf = stream.ToArray();
            //保存为Excel文件  
            using FileStream fs = new FileStream(fileName, FileMode.Create, FileAccess.Write);
            fs.Write(buf, 0, buf.Length);
            fs.Flush();
            if (isShowResult)
            {
                System.Windows.MessageBox.Show("保存成功!");
            }
        }

        /// <summary>
        /// 获取单元格类型
        /// </summary>
        /// <param name="cell"></param>
        /// <returns></returns>
        internal static object GetValueType(ICell cell)
        {
            if (cell == null)
            {
                return null;
            }

            switch (cell.CellType)
            {
                case CellType.Blank: //BLANK:  
                    return null;
                case CellType.Boolean: //BOOLEAN:  
                    return cell.BooleanCellValue;
                case CellType.Numeric: //NUMERIC:
                    if (DateUtil.IsCellDateFormatted(cell))
                    {
                        return cell.DateCellValue;
                    }
                    else
                    {
                        return cell.NumericCellValue;
                    }
                case CellType.String: //STRING:  
                    return cell.StringCellValue;
                case CellType.Error: //ERROR:  
                    return cell.ErrorCellValue;
                case CellType.Formula: //FORMULA:  
                default:
                    return "=" + cell.CellFormula;
            }
        }

        /// <summary>
        /// 将Excel的ISheet转化为DataTable
        /// </summary>
        /// <param name="sheet">NPOI中的一个ISheet</param>
        /// <returns></returns>
        internal static DataTable SheetToDataTable(ISheet sheet)
        {
            using var dt = new DataTable(sheet.SheetName);
            // 创建表列
            IRow header = sheet.GetRow(0);
            for (int i = header.FirstCellNum; i < header.LastCellNum; i++)
            {
                var value = GetValueType(header.GetCell(i));
                if (value == null | string.IsNullOrEmpty(value.ToString()))
                {
                    dt.Columns.Add($"Col{i}");
                }
                else
                {
                    dt.Columns.Add(value.ToString());
                }
            }
            // 添加行数据
            for (int i = 1; i <= sheet.LastRowNum; i++)
            {
                IRow row = sheet.GetRow(i);
                if (row == null)
                {
                    continue;
                }
                var dr = dt.NewRow();
                for (int j = 0; j < row.LastCellNum; j++)
                {
                    dr[j] = GetValueType(row.GetCell(j)) ?? "";
                }
                dt.Rows.Add(dr);
            }
            return dt;
        }

        /// <summary>
        /// 将DataTable数据存储至NPOI中的一个ISheet
        /// </summary>
        /// <returns></returns>
        internal static void DataTableToSheet(ref ISheet sheet, DataTable dt)
        {
            //表头  
            IRow headRow = sheet.CreateRow(0);
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                ICell cell = headRow.CreateCell(i);
                cell.SetCellValue(dt.Columns[i].ColumnName);
            }

            //数据  
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                IRow row = sheet.CreateRow(i + 1);
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    var dataType = dt.Columns[j].DataType;
                    if (dataType == typeof(string) | dataType == typeof(DateTime))
                    {
                        ICell cell = row.CreateCell(j, CellType.String);
                        cell.SetCellValue(dt.Rows[i][j].ToString());
                    }
                    else
                    {
                        ICell cell = row.CreateCell(j, CellType.Numeric);
                        bool isValue = double.TryParse(dt.Rows[i][j].ToString(), out double value);
                        if (isValue)
                        {
                            cell.SetCellValue(value);
                        }
                    }
                }
            }
        }
    }
```
