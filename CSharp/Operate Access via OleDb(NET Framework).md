# 使用 `System.Data.OleDb` 与 `Access` 数据库进行交互

若项目是基于`.NET Core` ，请使用 `Odbc`，详情请参阅 [C#——使用Odbc操作Access数据库 (.NET Core)](https://blog.csdn.net/qq_39395589/article/details/103800222)

```C#
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Linq;

namespace SomeNameSpace
{
    class AccessHelper
    {
        //定义连接字符串
        public static string ConnectionString =
            @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + AccessFilePath;

        /// <summary>
        /// 获取数据库中所有表名
        /// </summary>
        /// <returns></returns>
        public static List<string> GetAllTableNames()
        {
            List<string> result = new List<string>();
            using (OleDbConnection conn = new OleDbConnection(ConnectionString))
            {
                try
                {
                    conn.Open();
                    DataTable tbs = conn.GetSchema("tables");
                    foreach (DataRow dr in tbs.AsEnumerable().Where(x => x["TABLE_TYPE"].ToString() == "TABLE"))
                    {
                        result.Add(dr["TABLE_NAME"].ToString());
                    }
                }
                catch (Exception e)
                {
                    System.Windows.MessageBox.Show(e.Message);
                }
            }
            return result;
        }

        /// <summary>
        /// 更新数据库中表，实际上可以说是替换,若表不存在将自动创建
        /// </summary>
        /// <param name="dt">表</param>
        /// <param name="tableName">表名</param>
        public static void UpdateDBTable(System.Data.DataTable dt, string tableName)
        {
            if (!IsTableExist(tableName))
            {
                CreatDBTable(dt, tableName);
            }
            using (OleDbConnection conn = new OleDbConnection(ConnectionString))
            {
                try
                {
                    conn.Open();
                    string sql = $"delete * from {tableName}";
                    OleDbCommand odc = new OleDbCommand(sql, conn);
                    odc.ExecuteNonQuery();
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        string add_sql = $"Insert Into {tableName} Values('{dt.Rows[i].ItemArray[0]}'";
                        for (int j = 1; j < dt.Columns.Count; j++)
                        {
                            add_sql += $",'{dt.Rows[i].ItemArray[j]}'";
                        }
                        add_sql += ")";
                        odc.CommandText = add_sql;
                        odc.Connection = conn;
                        odc.ExecuteNonQuery();
                    }
                    odc.Dispose();
                }
                catch (Exception e)
                {
                    if (e.Message.Contains("查询值的数目与目标字段中的数目不同"))
                    {
                        DeleteDBTable(tableName);
                        UpdateDBTable(dt, tableName);
                    }
                    else
                    {
                        System.Windows.MessageBox.Show(e.Message);
                    }
                }
            }
        }

        /// <summary>
        /// 新建数据表
        /// </summary>
        /// <param name="dt">表</param>
        /// <param name="tableName">表名</param>
        public static bool CreatDBTable(System.Data.DataTable dt, string tableName)
        {
            if (IsTableExist(tableName))
            {
                System.Windows.MessageBox.Show("表已存在，请检查名称！");
                return false;
            }
            else
            {
                try
                {
                    using (OleDbConnection conn = new OleDbConnection(ConnectionString))
                    {
                        conn.Open();
                        //构建字段组合
                        string StableColumn = "";
                        for (int i = 0; i < dt.Columns.Count; i++)
                        {
                            Type t = dt.Columns[i].DataType;
                            if (t.Name == "String")
                            {
                                StableColumn += string.Format("{0} varchar", dt.Columns[i].ColumnName);
                            }
                            else if (t.Name == "Int32" || t.Name == "Double")
                            {
                                StableColumn += string.Format("{0} int", dt.Columns[i].ColumnName);
                            }
                            if (i != dt.Columns.Count - 1)
                            {
                                StableColumn += ",";
                            }
                        }
                        string sql = "";
                        if (StableColumn.Contains("ID int"))
                        {
                            StableColumn = StableColumn.Replace("ID int,", "");
                            sql = $"create table {tableName}(ID autoincrement primary key,{StableColumn}";
                        }
                        else
                        {
                            sql = $"create table {tableName}({StableColumn})";
                        }
                        OleDbCommand odc = new OleDbCommand(sql, conn);
                        odc.ExecuteNonQuery();
                        odc.Dispose();
                        return true;
                    }
                }
                catch (Exception e)
                {
                    System.Windows.MessageBox.Show(e.Message);
                    return false;
                }
            }
        }

        /// <summary>
        /// 删除数据库中表
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>
        public static bool DeleteDBTable(string tableName)
        {
            if (IsTableExist(tableName))
            {
                using (OleDbConnection conn = new OleDbConnection(ConnectionString))
                {
                    try
                    {
                        conn.Open();
                        string sql = $"drop table {tableName}";
                        OleDbCommand odc = new OleDbCommand(sql, conn);
                        odc.ExecuteNonQuery();
                        odc.Dispose();
                        return true;
                    }
                    catch (Exception e)
                    {
                        System.Windows.MessageBox.Show(e.Message);
                        return false;
                    }
                }
            }
            else { return false; }
        }

        /// <summary>
        /// 查询表是否存在
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>
        public static bool IsTableExist(string tableName)
        {
            using (OleDbConnection conn = new OleDbConnection(ConnectionString))
            {
                try
                {
                    conn.Open();
                    string sql = $"select * from {tableName}";
                    OleDbCommand odc = new OleDbCommand(sql, conn);
                    odc.ExecuteNonQuery();
                    odc.Dispose();
                    return true;
                }
                catch (Exception e)
                {
                    System.Windows.MessageBox.Show(e.Message);
                    return false;
                }
            }
        }

        /// <summary>
        /// 获取数据库中表
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>
        public static DataTable GetDBTable(string tableName)
        {
            if (!IsTableExist(tableName))
            {
                return null;
            }
            using (OleDbConnection conn = new OleDbConnection(ConnectionString))
            {
                try
                {
                    conn.Open();
                    string sql = $"select * from {tableName}";
                    DataTable dt = new DataTable();
                    OleDbDataAdapter oda = new OleDbDataAdapter(sql, conn);
                    oda.Fill(dt);
                    oda.Dispose();
                    return dt;
                }
                catch (Exception e)
                {
                    System.Windows.MessageBox.Show(e.Message);
                    return null;
                }
            }
        }
    }
}
```
