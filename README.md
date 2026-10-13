# MiniStats

**Ein kompaktes World-of-Warcraft-Addon für WoW Forever Beta.**

MiniStats zeigt dein Gold, Silber und Kupfer sowie freie Taschenplätze in einer transparenten Leiste unter der Minimap. So behältst du Geld und Stauraum auch unterwegs im Blick.

## Funktionen

- Farbige Geldanzeige mit Münzsymbol.
- Freie und gesamte Taschenplätze, inklusive Spezialtaschen; ohne Bank und Schlüsselbund.
- Automatische Aktualisierung und Tooltips mit weiteren Details.
- Frei verschiebbare Leiste mit gespeicherter Position pro Charakter.
- Passt sich der Breite von MiniExpBar oder der Minimap an. MiniExpBar ist optional.

## Installation

1. Lade das Repository herunter und benenne den entpackten Addon-Ordner in `MiniStats` um.
2. Kopiere ihn nach `World of Warcraft/<Spielversion>/Interface/AddOns/`. Die Dateien `MiniStats.toc` und `MiniStats.lua` müssen direkt im Ordner `MiniStats` liegen.
3. Starte das Spiel neu und aktiviere **MiniStats** in der Addon-Liste der Charakterauswahl.

## Bedienung

Die Leiste erscheint automatisch unter MiniExpBar, falls vorhanden, oder unter der Minimap. `4 (10)` bedeutet beispielsweise **4 freie von 10 Taschenplätzen**.

Halte die **linke Maustaste** auf der Leiste gedrückt, um sie zu verschieben. Mit folgendem Befehl setzt du ihre Position zurück:

```text
/ministats reset
```

## Kompatibilität

Entwickelt für **WoW Forever Beta**, Interface-Version **16001**. Keine weiteren Addons erforderlich.
