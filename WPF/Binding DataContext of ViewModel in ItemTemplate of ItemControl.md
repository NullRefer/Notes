# 为 ItemControl 的 ItemTemplate 绑定 ViewModel 的 DataContext 中的属性

在为 `ItemControl` 编写 `ItemTemplate` 时候，需要使用到 `UserControl` 的 `DataContext`，即与绑定集合同等地位的属性，例如下述代码：

``` xml
<ListBox ItemsSource="{Binding Collections}">
	<ListBox.ItemTemplate>
		<DataTemplate>
			<UniformGrid Columns="2">
				<TextBlock Text="{Binding Name}" />
				<ComboBox ItemsSource="{Binding ?}" SelectedValue="{Binding Type}" />
			</UniformGrid>
		</DataTemplate>
	</ListBox.ItemTemplate>
</ListBox>
```

> **注意到在 `ListBox` 的绑定中，由于 `ItemTemplate` 默认绑定到了集合的单个对象，因此无法采用直接的方式绑定到 `UserControl` 的 `DataContext` 中的属性，即对应的 `ViewModel.OtherCollections` 。**

因此，使用 `FindAncestor` 的绑定方式，通过获取 `UserControl` 的 `DataContext` ，继而间接绑定到 `ViewModel` 中的集合，`ComboBox` 的绑定代码如下：

``` xml
<ComboBox ItemsSource="{Binding RelativeSource={RelativeSource AncestorType=UserControl},
	Path=DataContext.OtherCollections}" SelectedValue="{Binding Type}" />
```

其中 `ViewModel.cs` 相关代码如下（项目引用了 [MVVMLight](http://www.mvvmlight.net/) 包）：

``` C#
class ViewModel : ViewModelBase
{
	// Other Definitions
	//...
	private ObservableCollection<Foo> _collections;
	public ObservableCollection<Foo> Collections
	{
		get => _collections;
		Set => Set(ref _collections, value);
	}
	public List<Bar> OtherCollections => new List<Bar>();
}
```
