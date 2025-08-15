using System.Globalization;
using Avalonia.Media;
namespace Avalonia.Controls.IconsHero.Internal;

internal static class CodeConverter
{
    private static readonly Lazy<Dictionary<IconsHeroCode, CodeAttribute>> CachedCodes = new (LoadCodes);

    public static CodeInfo GetInfo(this IconsHeroCode code)
    {
        var attribute = CachedCodes.Value[code];
        var content = char.ConvertFromUtf32(int.Parse(attribute.Code, NumberStyles.HexNumber, NumberFormatInfo.InvariantInfo));

        var fontFamily = attribute.FontFamily switch
        {
            Font.PhosphorRegular => new FontFamily("avares://Avalonia.Controls.IconsHero/Assets/fonts/ph/#Phosphor"),
            Font.PhosphorFill => new FontFamily("avares://Avalonia.Controls.IconsHero/Assets/fonts/ph/#Phosphor-Fill"),
            Font.FluentSystemIconsRegular => new FontFamily("avares://Avalonia.Controls.IconsHero/Assets/fonts/fluent/#FluentSystemIcons-Regular"),
            Font.FluentSystemIconsFilled => new FontFamily("avares://Avalonia.Controls.IconsHero/Assets/fonts/fluent/#FluentSystemIcons-Filled"),
            _ => throw new ArgumentOutOfRangeException(nameof(attribute.FontFamily), $"Cannot find font family for selected code: {attribute.FontFamily}"),
        };

        return new (content, fontFamily);
    }

    private static Dictionary<IconsHeroCode, CodeAttribute> LoadCodes()
    {
        var result = new Dictionary<IconsHeroCode, CodeAttribute>();
        var fields = typeof(IconsHeroCode).GetFields();

        foreach (var field in fields)
        {
            if (field.GetCustomAttributes(typeof(CodeAttribute), false) is not CodeAttribute[] { Length: > 0 } attributes)
                continue;

            var attribute = attributes[0];
            var code = (IconsHeroCode) field.GetValue(null)!;
            result[code] = attribute;
        }

        return result;
    }
}
