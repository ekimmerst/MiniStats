# MiniStats

**A compact World of Warcraft addon for WoW Forever Beta.**

MiniStats displays your gold, silver, copper, and free bag slots in a transparent bar below the minimap. Keep track of your money and storage space wherever you go.

## Features

- Color-coded money display with a coin icon.
- Free and total bag slots, including specialty bags; excludes the bank and keyring.
- Automatic updates and tooltips with additional details.
- Freely draggable bar with its position saved per character.
- Matches the width of MiniExpBar or the minimap. MiniExpBar is optional.

## Installation

1. Download the repository and rename the extracted addon folder to `MiniStats`.
2. Copy it to `World of Warcraft/<game-version>/Interface/AddOns/`. The files `MiniStats.toc` and `MiniStats.lua` must be directly inside the `MiniStats` folder.
3. Restart the game and enable **MiniStats** in the addon list on the character selection screen.

## Usage

The bar automatically appears below MiniExpBar, if available, or below the minimap. For example, `4 (10)` means **4 free slots out of 10 total bag slots**.

Hold the **left mouse button** on the bar to drag it. Use the following command to reset its position:

```text
/ministats reset
```

## Compatibility

Designed for **WoW Forever Beta**, interface version **16001**. No other addons are required.
