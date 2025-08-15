namespace Avalonia.Controls.IconsHero.Internal;

internal sealed class CodeAttribute(string code, Font font) : Attribute
{
    public string Code { get; } = code;
    public Font FontFamily { get; } = font;
}
