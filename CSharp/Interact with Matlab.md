# C#与 Matlab 交互

开发环境: Visual Studio 2019, .NetFramework 4.5, Matlab 2018b

## 1. C# 调用 Matlab

---

基本思路: 将 `.m` 文件（`matlab` 函数）打包为 `.dll` 文件以供 `C#` 调用

1. `Matlab` 端操作
    1. 编写 `matlab` 函数

        ```matlab
        function [x] = linear_equation_solve(A, b)
        %% 求解线性方程组 Ax = b
        x = A / b;
        end
        ```

    2. 将函数文件打包为 `*.dll` 文件（使用matlab compiler）
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/2019082613062929.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM5Mzk1NTg5,size_16,color_FFFFFF,t_70)

    3. 将打包得到的文件和 `MWArray.dll` 拷贝至需要引用的项目目录中，打包得到的文件一般包含 `$function$.dll`, `$function$Native.dll`，`MWArray.dll` 可在 `Matlab` 的安装目录中找到
     >Native和非Native的区别为: 用XXXXNative.dll在调用的时候，直接对参数采用了object类型，matab计算引擎会自己去识别。而非XXXXNative.dll都采用了精确的数据类型。参考： [Matlab生成C#dll ，native 与非native的效率比较](https://www.ilovematlab.cn/thread-205793-1-1.html)

2. `Visual Studio` 端操作：将 `$function$Native.dll` 和 `MWArray.dll` 添加至项目引用即可

    ```C#
    using System;
    using LinearEquationSolver;
    using MathWorks.MATLAB.NET.Arrays;

    namespace MatlabToDotNetSample{
        class Program{
            static void Main(string[] args){
                int[,] b_array = new int[,]{
                    {1}, {2}, {3}
                };
                int[,] a_array = new int[,]{
                    {1, 2, 3},
                    {4, 5, 6},
                    {7, 8, 9}
                };
                var A = new MWNumericArray(A_array);
                var b = new MWNumericArray(b_array);
                var result = new LinearEquationSolver.LinearEquationSolver().linear_equation_solve(A, b);
                }
        }
    }
    ```
