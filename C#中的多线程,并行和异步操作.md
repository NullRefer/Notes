# C# 多线程、并行和异步编程

## 1.进程

进程是一个运行程序。进程是一个操作系统级别的概念，用来描述一组资源（比如外部代码库和主线程）和程序运行必须的内存分配。对于每一个加载到内存的*.exe，在它的生命周期中操作系统会为之创建一个单独且隔离的进程。

由于一个进程的失败不会影响其他进程，使用这种隔离方式，运行环境将更加健壮和稳定。此外，一个进程无法访问另外一个进程中的数据，除非 使用**WCF**这种分布式计算编程的API。所以，进程是一个正在运行的应用程序的固定的安全的边界。

每一个**Windows**进程都有一个唯一的进程标识符，即**PID**，当需要时，它们能被操作系统加载和卸载。

---

## 2.线程

线程是进程中的基本执行单元。

每一个Windows进程都包含一个用作程序入口点的主线程。进程的入口点创建的第一个线程被称为主线程。.Net控制台程序使用Main()方法作为程序入口点。当调用该方法时，会自动创建主线程。
仅包含一个主线程的进程是线程安全的，这是由于在某个特定时刻只有一个线程访问程序中的数据。然而，如果这个线程正在执行一个复杂的操作，那么这个线程所在的进程（特别是GUI程序）对用户来说会显得没有响应一样。

因此，主线程可以产生次线程（也称为工作者线程，worker thread）。每一个线程（无论主线程还是次线程）都是进程中的一个独立执行单元，它们能够同时访问那些共享数据。

开发者可以使用多线程改善程序的总体响应性，让人感觉大量的活动几乎在同一时间发送。比如，一个应用程序可以产生一个工作者线程来执行强度大的工作。当这个次线程正在忙碌的时候，主线程仍然对用户的输入保持响应，这使得整个进程具有更强的性能。当然，如果单个进程中的线程过多的话，性能反而会下降，因为CPU需要花费不少时间在这些活动的线程来回切换。

单CPU的计算机并没有能力在同一时间运行多个线程。准确地说，在一个单位时间（即一个时间片）内，单CPU只能根据线程优先级执行一个线程。当一个线程的时间片用完的时候，它会被挂起，以便执行其他线程。对于线程来说，它们需要在挂起前记住发生了什么，它们把这些情况写到线程本地存储中（Thread Local Storage，TLS），并且它们还要获得一个独立的调用栈（call stack）。

---

## 3.使用Thread创建线程

``` C#
static void Main(string[] args){
    Thread t = new Thread(new ThreadStart(Print));
    t.Name = "打印线程";
    t.Start();
    Console.ReadKey();
}

private void Print(){
    for (i = 0; i < 10; i++){
        Console.WriteLine($"This is the #{i + 1} time...");
        Thread.Sleep(500);
    }
}
```

>使用Thread创建的线程优先级皆为Normal,如果想要在启动线程时把数据传递给任务，则在new Thread中应该使用new ParameterizedThreadStart委托创建线程，同时t.Start(object)把object传递给Print
>使用Thread创建的线程默认为后台线程，即IsBackground = True，这将使得，当前台线程结束后，即使后台线程尚未完成，程序也将关闭。故对于可不必须做完的任务，都将其IsBackground设为True，而对于一些重要任务，可以将其设为前台线程，即IsBackground = False

---

## 4.多线程访问公共资源问题

对于多线程访问公共资源时，可能会发生资源的争抢，因此需要用lock将目标资源锁定，防止混乱。

``` C#
// 使用readonly object locker = new object()来锁定资源

lock(locker){
    // Manipulate resource
    ...
}
```

---

## 5.线程池

线程池的好处：

- 线程池减少了线程创建、启动的次数，提高了效率
- 使用线程池，可以让我们更加专注在业务逻辑而不是多线程的架构上

然而线程池中的线程始终是后台线程，且它的优先级是默认的normal

---

## [6.使用任务并行库进行并行编程](https://docs.microsoft.com/zh-cn/dotnet/standard/parallel-programming/task-based-asynchronous-programming)

任务并行库(TPL)以“任务”的概念为基础，后者表示异步操作。在某些方面，任务类似于线程或者`ThreadPool`工作项，但是抽象级别更高。术语“任务并行”是指一个或多个独立的任务同时运行。任务提供两个主要好处。

1. 系统的使用效率更高，可伸缩性更好。

    - 在后台，任务排队到已使用算法增强的`ThreadPool`，这些算法能够确定线程数并随之调整，提供负载平衡以实现吞吐量最大化。这会使任务相对轻量，你可以创建很多任务以启用细化并行。

2. 对于线程或者工作项，可以使用更多的编程控件。

    - 任务和围绕它们生成的框架提供了一组丰富的API，这些API支持等待、取消、继续、可靠的异常处理、详细状态、自定义计划等功能

出于这两个原因，在`.NET Framework`中,TPL是用于编写多线程、异步和并行代码的首选API。

1. 数据并行

- **Parallel**类支持两个主要的静态方法,     Parallel.For和Parallel.ForEach方法,这两个方法对数组或集合中的数据进行迭代.

    ``` C#
    List<int> list = new List<int>();
    for (i = 0; i < 100; i++){
        list.Add(100);
    }
    // Parallel.For(int fromInclusive, int toExclusive, Action<int> body)
    Parallel.For(0, list.Count, index => {
        Console.WriteLine(list[index]);
    });
    // Parallel.ForEach(IEumerable<T> source, Action<T> body)
    Parallel.ForEach(list, item =>{
        Console.WriteLine(item);
    });
    ```

1. 任务并行

- 隐式创建和运行任务，**Parallel.Invoke**方法触发多个异步任务

    ``` C#
    // Parallel.Invoke(params Action[] actions)
    Parallel.Invoke(
        () => {
            Console.WriteLine("This is the 1st task...");
        },
        () =>{
            Console.WriteLine("This is the 2nd task...");
        }
    );
    ```

- 显示创建和运行任务
  - 不返回值的任务由`System.Threading.Tasks.Task`类来表示。返回值的任务由`System.Threading.Tasks.Task<TResult>`类表示，该类从`Task`继承。任务对象处理基础结构详细信息，并提供可在任务的整个生存期从调用线程访问的方法和属性。例如，可以随时访问任务的`Status`属性，以确定它是一开始运行、已完成运行、已取消还是引发了异常。状态由`TaskStatus`枚举表示。
  - 在创建任务时，你赋予它一个用户委托，该委托封装该任务将执行的代码。该委托可以表示为命名的委托、匿名方法或lambda表达式。lambda表达式可以包含对命名方法的调用，如下面的示例所示。请注意，该实例包含对`Task.Wait`方法的调用，以确保任务在控制台模式应用程序结束之前完成执行。

    ``` C#
    static void Main(){
        Thread.CurrentThread.Name = "Main";

        // Create a task and supply a user delegate by using a lambda expression
        Task taskA = new Task(() =>
            Console.WriteLine("Hello from taskA"););
        // Start the task
        taskA.Start();
        // Output a message from the calling thread.
        Console.WriteLine($"Hello from thread{Thread.CurrentThread.Name}");
        taskA.Wait();
    }
    ```

- 使用`Task.Factory.StartNew`创建任务

    ``` C#
    // 1. 无参，无返回值的创建新任务
    Task.Factory.StarNew(() =>{
        Console.WriteLine("This is new task");
    });
    // 2.无参，有返回值的创建新任务
    var task = Task.Factory.StartNew(() =>{
        int sum = 0;
        for (i = 0; i < 100; i++){
            sum += i;
        }
        return sum;
    })
    Console.WriteLine(task.Result);
    // 3. 有参，无返回值创建新任务
    List<int> list = new List<int>(){
        1, 2, 3, 4, 5,
        6, 7, 8, 9, 10
    };
    Task.Factory.StartNew(state =>{
        List<int> para = state as List<int>;
        for (i = 0; i < para.Count; i ++){
            Console.WriteLine(para[i]);
        }
    }, list);
    // 4. 有参，有返回值创建新任务
    var task = Task.Factory.StarNew(state =>{
        List<int> para = state as List<int>;
        int sum = 0;
        for (i = 0; i < para.Count; i ++){
            sum += para[i];
        }
        return sum;
    }, list);
    Console.WriteLine(sum);
    ```

> `Task.Factory.StartNew`极其强大，很多异步运行的任务都可以使用该方法进行，参考例程详见[MSDN官方介绍：基于任务的异步编程](https://docs.microsoft.com/zh-cn/dotnet/standard/parallel-programming/task-based-asynchronous-programming)

## [7.异步编程Async](https://docs.microsoft.com/zh-cn/dotnet/csharp/programming-guide/concepts/async/)

C# 的`async`关键字用来指定某个方法,`lambda`表达式或者匿名方法自动以异步的方式来调用,CLR会创建新的执行线程来处理任务.在调用`asyn`方法时,`await`关键字会自动暂停当前线程中任何其他活动,直到任务完成,离开调用线程,并继续未完成的任务.
>这个用法比较复杂，建议先熟练掌握`Task`类的用法。
