# MathNet.Numerics 的一些使用实例

## 1.使用LU分解求解线性方程组Ax=b的解(2019.3.17)

---

首先创建一个矩阵A，矩阵数据可以使用二维数组作为源数据，使用`DenseMatrix.OfArray(double[,] array)`进行创建

```C#
double[,] A =
{
    {3, 1.4,0,0 },
    {1.4, 2, 2.1, 0 },
    {0 ,2.1,4,3 },
    {0,0,3,3.4 }
};
Matrix<double> matrix = DenseMatrix.OfArray(A);
```

然后创建列向量b，为`DenseVector`对象，可以直接使用`new DenseVector(double[] array)`构造

```C#
DenseVector b = new DenseVector(new double[] {1, 2, 3, 4});
```

调用 `matrix.LU()` 进行 LU 分解，`LU()` 返回的对象实现了 `ISolver<T>` 接口，可以直接调用 `Solve(b)` 解出方程

```C#
var X = matrix.LU().Solve(b)
```

这样 `X` 便是方程组 `AX=b` 的解了

## 2.将 `Matrix` 导出成 `*.mat` 文件，使用 `Matlab` 打开(2019/5/9)

---

要将 `Matrix` 导出为 `*.mat` 文件，首先需要从 `Nuget` 安装 `MathNet.Numerics.Data.Matlab`,
添加引用`MathNet.Numerics.Data.Matlab`
在该名称空间下，主要使用
`MatlabWriter.Pack(Matrix<T> matrix, string matrixName)`
`MatlabWriter.Store(string filePath, IEnumerable<MatlabMatrix> matrices)`

Example:

```C#
List<MatlabMatrix> ms = new List<MatlabMatrix>
{
    MatlabWriter.Pack(A, "A"),
    MatlabWriter.Pack(DenseMatrix.OfColumnVectors(b), "b"),
    MatlabWriter.Pack(DenseMatrix.OfColumnVectors(x), "x")
};
MatlabWriter.Store(FilePath, ms);
```
