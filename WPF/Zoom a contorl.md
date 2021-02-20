# 对控件进行缩放

控件的缩放属于 `Transform`, 而对于需要以鼠标位置为中心进行缩放则为 `MatrixTransform`, 为保证 `MVVM` 的一致性，采用 `System.Windows.Interactivity` 中的 `Behavior` 实现, 下面为实现控件缩放的方法..
>[StackOverflow: WPF Zoom Canvas Center on Mouse Position
](https://stackoverflow.com/questions/46424149/wpf-zoom-canvas-center-on-mouse-position)

ZoomOnMouseWheel.cs

``` csharp

using System.Windows;
using System.Windows.Input;
using System.Windows.Interactivity;
using System.Windows.Media;

namespace Demo.Utils
{
    public class ZoomOnMouseWheel : Behavior<FrameworkElement>
    {
        public Key? ModifierKey { get; set; } = null;
        public TransformMode TranformMode { get; set; } = TransformMode.Render;

        private Transform _transform;

        protected override void OnAttached()
        {
            if (TranformMode == TransformMode.Render)
            {
                _transform = AssociatedObject.RenderTransform = new MatrixTransform();
            }
            else
            {
                _transform = AssociatedObject.LayoutTransform = new MatrixTransform();
            }

            AssociatedObject.MouseWheel += AssociatedObject_MouseWheel;
        }

        protected override void OnDetaching()
        {
            AssociatedObject.MouseWheel -= AssociatedObject_MouseWheel;
        }

        private void AssociatedObject_MouseWheel(object sender, MouseWheelEventArgs e)
        {
            if ((!ModifierKey.HasValue || !Keyboard.IsKeyDown(ModifierKey.Value)) && ModifierKey.HasValue)
            {
                return;
            }

            if (!(_transform is MatrixTransform transform))
            {
                return;
            }

            var pos1 = e.GetPosition(AssociatedObject);
            var scale = e.Delta > 0 ? 1.1 : 1 / 1.1;
            var mat = transform.Matrix;
            mat.ScaleAt(scale, scale, pos1.X, pos1.Y);
            transform.Matrix = mat;
            e.Handled = true;
        }
    }

    public enum TransformMode
    {
        Layout,
        Render,
    }
}

```

View.xaml

``` xml

<UserControl ...
    xmlns:interactivity="http://schemas.microsoft.com/expression/2010/interactivity"
    xmlns:local="clr-namespace:Demo.Utils">

    <Canvas>
        <interactivity:Interaction.Behaviors>
            <local:ZoomOnMouseWheel ModifierKey="LeftCtrl" TransformMode="Layout">
        </interactivity:Interaction.Behaviors>
    </Canvas>
</UserControl>
```
