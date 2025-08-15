using Avalonia.Controls.IconsHero.Internal;

namespace Avalonia.Controls.IconsHero;

public partial class IconsHero : UserControl
{
    public static readonly StyledProperty<IconsHeroCode> CodeProperty = AvaloniaProperty.Register<IconsHero, IconsHeroCode>(nameof(Code), defaultValue: IconsHeroCode.Phosphor_Acorn_Fill);

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
