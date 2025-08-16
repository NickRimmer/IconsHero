namespace IconsHero.Controls.Avalonia.Internal;

internal sealed class CodeAttribute(string code, Font font) : Attribute
{
    public string Code { get; } = code;
    public Font FontFamily { get; } = font;
}
