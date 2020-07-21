# 实现使用鼠标拖动 Control

主要思路：对控件添加3个事件：`MouseLeftButtonDown`、`MouseLeftButtonUp`、`MouseMove`

`MouseLeftButtonDown` 用于判定拖动触发，当鼠标在控件区域按下时，激活拖动标志位

`MouseLeftButtonUp` 用于判定拖动结束，当鼠标在控件区域弹起时，关闭拖动标志位

`MouseMove` 用于判定是否拖动：当拖动标志位激活时，获取鼠标当前的位置 `e.GetPosition(this.Parent as UIElement)` 对当前控件做平移变换 `RenderTransform`

前端代码(拖动Grid)

``` xml
<Grid Height="50" Width="50" Name="myGrid" MouseLeftButtonDown="grid_MouseLeftButtonDown" MouseLeftButtonUp="
    grid_MouseLeftButtonUp" MouseMove="grid_MouseMove">
    <Ellipse Fill="Yellow" Stroke="Blue" Height="50" Width="50" HorizontalAlignment="Left"></Ellipse>
    <TextBlock Text="5" TextAlignment="Center" VerticalAlignment="Center" HorizontalAlignment="Center"></TextBlock>
    <Grid.RenderTransform>
        <TranslateTransform x:Name="tt" />
    </RenderTransform>
</Grid>
```

后端cs

```C#
private bool isDragging;
private Point startPosition;

private void grid_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
{
    isDragging = true;
    var draggableElement = sender as UIElement;
    var clickPosition = e.GetPosition(this);

    var transform = draggableElement.RenderTranform as TranslateTransform;
    startPosition.X = clickPosition.X - transform.X;    //注意减号
    startPosition.Y = clickPosition.Y - transform.Y;
    draggableElement.CaptureMouse();
}

private void grid_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
{
    isDragging = false;
    var draggableElement = sender as UIElement;
    draggableElement.ReleaseMouseCapture();
}

private void grid_MouseMove(object sender, MouseEventArgs e)
{
    var draggableElement = sender as UIElement;
    if (isDragging && draggableElement != null)
    {
        Point currentPosition = e.GetPosition(this.Parent as UIElement);
        var transform = draggableElement.RenderTransform as TranslateTransform;

        transform.X = currentPosition.X - startPosition.X;
        transform.Y = currentPosition.Y - startPosition.Y;
     }
}
```
