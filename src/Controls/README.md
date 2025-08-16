# Avalonia.Controls.IconsHero

Hero icon controls for Avalonia UI.

## Features
- Fluent and Phosphor icon fonts
- Easy integration with Avalonia projects

## Usage
Add the NuGet package to your Avalonia project and use the icon controls in your XAML.

```xml
<StackPanel Orientation="Horizontal" Spacing="5" VerticalAlignment="Top">
    <TextBlock Text="Example: " />
    <iconsHero:IconsHero Code="Fluent_Heart_Filled"
                         FontSize="18"
                         Foreground="Red" />
</StackPanel>
```

### Properties

| Property     | Type     | Description                            |
| ------------ | -------- | -------------------------------------- |
| `Code`       | `enum`   | Icon code from the built-in icon sets  |
| `FontSize`   | `double` | Icon size in device-independent pixels |
| `Foreground` | `IBrush` | Icon color                             |

---

## License
MIT

