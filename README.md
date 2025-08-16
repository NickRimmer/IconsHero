# IconsHero

[![NuGet](https://img.shields.io/nuget/v/IconsHero.Controls.Avalonia.svg)](https://www.nuget.org/packages/IconsHero.Controls.Avalonia/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**IconsHero** is a lightweight Avalonia control that allows you to easily use **font-based icons** in your applications.
Currently supports:

* **Phosphor** – Regular & Fill weights
* **Fluent UI System Icons** – Regular & Filled

---

## ✨ Features

* Simple – icons selected via `enum` values.
* Works with standard Avalonia properties: `FontSize` and `Foreground`.

---

## 📦 Installation

Install via NuGet:

```powershell
dotnet add package IconsHero.Controls.Avalonia
```

---

## 🚀 Usage

Then place an icon in your UI:

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

## 📄 License

[MIT](LICENSE)

---

## 💡 Notes

* Requires **Avalonia 11.0** or later.
* More icon fonts may be added in the future based on feature requests.
