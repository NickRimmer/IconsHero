using Avalonia;
using Avalonia.Controls;
using IconsHero.Controls.Avalonia.Internal;
namespace IconsHero.Controls.Avalonia;

public partial class IconsHero : UserControl
{
    public static readonly StyledProperty<IconsHeroCode> CodeProperty =
        AvaloniaProperty.Register<IconsHero, IconsHeroCode>(nameof(Code), defaultValue: IconsHeroCode.Fluent_Heart_Filled);

    public IconsHero()
    {
        InitializeComponent();
    }

    public IconsHeroCode Code
    {
        get => GetValue(CodeProperty);
        set => SetValue(CodeProperty, value);
    }

    protected override void OnAttachedToVisualTree(VisualTreeAttachmentEventArgs e)
    {
        var icon = this.GetControl<TextBlock>("TextBlockIcon");
        var codeInfo = Code.GetInfo();

        icon.Text = codeInfo.Content;
        icon.FontFamily = codeInfo.FontFamily;

        base.OnAttachedToVisualTree(e);
    }
}
