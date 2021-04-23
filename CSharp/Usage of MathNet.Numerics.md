# MathNet.Numerics 的一些使用实例

## 1.使用LU分解求解线性方程组Ax=b的解(2019.3.17)

---

首先创建一个矩阵 `A`，矩阵可以通过二维数组初始化，使用 `DenseMatrix.OfArray(double[,] array)` 进行创建

```CSharp
double[,] A =
{
    {3, 1.4,0,0 },
    {1.4, 2, 2.1, 0 },
    {0 ,2.1,4,3 },
    {0,0,3,3.4 }
};
Matrix<double> matrix = DenseMatrix.OfArray(A);
```

然后创建列向量 `b`，为 `Vector` 对象，可以直接使用 `new DenseVector(double[] array)` 构造

```CSharp
DenseVector b = new DenseVector(new double[] {1, 2, 3, 4});
```

调用 `matrix.LU()` 进行 LU 分解，`LU()` 返回的对象实现了 `ISolver<T>` 接口，可以直接调用 `Solve(b)` 解出方程

```CSharp
var x = matrix.LU().Solve(b)
```

这样 `x` 便是方程组 `Ax=b` 的解了

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

## 3. 对采样信号进行 FFT

---

对于采样信号 `SamplePoints`, 采用 `Fourier` 类对其进行**FFT**

```CSharp
// 当采样信号均为实数数据
// 设定采样频率为 20 kHz
int sampleRate = 20000;
// 选择前1000个点进行FFT
double[] samplePoints = new double[1000];
// 准备虚部，全部设为0
double[] imag = new double[1000];
// 进行FFT变换
// 这里Option最好选matlab，这样得到的结果就和在matlab中FFT的结果一样
// 后续也好将各个频率对应的幅值计算出来
Fourier.Forward(samplePoints, imag, Options.Matlab)

```
