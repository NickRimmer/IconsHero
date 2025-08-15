namespace Avalonia.Controls.IconsHero.Internal;

internal class CodeAttribute(string code, Font font) : Attribute
{
    public string Code { get; } = code;
    public Font FontFamily { get; } = font;
}
