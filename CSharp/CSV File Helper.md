# C#中 `DataTable` 与 CSV 相互转换

``` C#
    /// <summary>
    /// CSV小帮手
    /// </summary>
    public static class CSVHelper
    {
        /// <summary>
        /// CSV转化为DataTable
        /// </summary>
        /// <param name="filePath">CSV文件路径</param>
        /// <returns></returns>
        public static DataTable CSVToDataTable(string filePath = null)
        {
            if (string.IsNullOrEmpty(filePath))
            {
                using var ofd = new OpenFileDialog
                {
                    Filter = "CSV (逗号分隔)(*.csv)|*.csv",
                    DefaultExt = "csv"
                };
                if (ofd.ShowDialog() == DialogResult.OK)
                {
                    filePath = ofd.FileName;
                }
                else
                {
                    return null;
                }
            }
            // 以下部分参考自Github@Jimmey-Jiang：Common.Utility
            using DataTable dt = new DataTable();
            int intColCount = 0;
            bool isHeaderColumn = true;
            DataColumn column;
            DataRow row;
            using var reader = new StreamReader(filePath, Encoding.UTF8);
            string strline;
            while (!string.IsNullOrEmpty(strline = reader.ReadLine()))
            {
                string[] aryline = strline.Split(new char[] { ',' });
                if (isHeaderColumn)
                {
                    isHeaderColumn = false;
                    intColCount = aryline.Length;
                    for (int i = 0; i < aryline.Length; i++)
                    {
                        column = new DataColumn(aryline[i]);
                        dt.Columns.Add(column);
                    }
                    continue;
                }

                row = dt.NewRow();
                for (int i = 0; i < intColCount; i++)
                {
                    row[i] = aryline[i];
                }
                dt.Rows.Add(row);
            }
            return dt;
        }

        /// <summary>
        /// DataTable转化为CSV文件
        /// </summary>
        /// <param name="dt">需要导出的DataTable</param>
        /// <param name="fileName">CSV文件路径</param>
        public static void DataTableToCSV(DataTable dt, string fileName = null, bool isShowResult = true)
        {
            if (string.IsNullOrEmpty(fileName))
            {
                using var sfd = new SaveFileDialog
                {
                    Filter = "CSV (逗号分隔)(*.csv)|*.csv",
                    DefaultExt = "csv"
                };
                if (sfd.ShowDialog() == DialogResult.OK)
                {
                    fileName = sfd.FileName;
                }
                else
                {
                    return;
                }
            }
            if (dt == null)
            {
                throw new ArgumentNullException(nameof(dt));
            }
            // 以下部分参考自Github@Jimmey-Jiang：Common.Utility
            StringBuilder csvText = new StringBuilder();
            StringBuilder csvrowText = new StringBuilder();
            foreach (DataColumn dc in dt.Columns)
            {
                csvrowText.Append(",");
                csvrowText.Append(dc.ColumnName);
            }
            csvText.AppendLine(csvrowText.ToString().Substring(1));

            foreach (DataRow dr in dt.Rows)
            {
                csvrowText = new StringBuilder();
                foreach (DataColumn dc in dt.Columns)
                {
                    csvrowText.Append(",");
                    csvrowText.Append(dr[dc.ColumnName].ToString().Replace(',', ' '));
                }
                csvText.AppendLine(csvrowText.ToString().Substring(1));
            }
            File.WriteAllText(fileName, csvText.ToString(), Encoding.UTF8);
            if (isShowResult)
            {
                MessageBox.Show("CSV保存成功!", "提示");
            }
        }
    }
```
