# quickshell-neon-drift

**Neon Drift** is an animated live background for [Quickshell](https://quickshell.org),
built for [Omarchy](https://learn.omacom.io/2/the-omarchy-manual) (Hyprland).
It renders a dark gradient backdrop, a slowly pulsing horizon glow, a fading
synthwave-style grid, and a handful of neon streaks drifting across the
screen — all colored from Omarchy's **live** theme palette.

If Omarchy isn't installed, or no theme is active yet, it falls back to a
built-in neon palette (magenta / cyan / violet / green on near-black), so it
also works as a stand-alone Quickshell background.

## How it fits together

```
shell.qml              entry point: one PanelWindow per screen, on the
                        Wayland background layer
modules/
  qmldir                declares Palette as a singleton
  Palette.qml            reads ~/.config/omarchy/current/theme/colors.toml
                          (live-reloaded) and exposes background/accent
                          colors, with a built-in fallback palette
  DriftField.qml          the actual visual: gradient backdrop, horizon
                          glow, grid, and drifting neon streaks
install.sh              symlinks this repo into ~/.config/quickshell/neon-drift
```

Live theme integration works the same way as other Omarchy Quickshell
configs: `Palette.qml` watches Omarchy's `colors.toml` and re-applies
whenever you run `omarchy theme set <name>`, no restart needed.

## Requirements

- [Quickshell](https://quickshell.org) (Qt 6, with the `QtQuick.Effects`
  module used for the glow/blur)
- A wlroots-based Wayland compositor (Hyprland, as used by Omarchy)
- [Omarchy](https://learn.omacom.io/2/the-omarchy-manual) — optional, only
  needed for live palette syncing; Neon Drift runs fine without it

## Install

```sh
git clone https://github.com/BernhardRode/quickshell-neon-drift.git
cd quickshell-neon-drift
./install.sh
```

This symlinks the repo to `~/.config/quickshell/neon-drift`. Then start it:

```sh
qs -n -d -c neon-drift
```

- `-c neon-drift` resolves to `~/.config/quickshell/neon-drift/shell.qml`
- `-d` daemonizes the process
- `-n` makes re-launching idempotent (won't spawn a second instance)

To start Neon Drift automatically with Hyprland, add to `~/.config/hypr/hyprland.conf`
(or Omarchy's autostart config):

```
exec-once = qs -n -d -c neon-drift
```

## Configuration

Edit the `DriftField { ... }` block at the bottom of `shell.qml` (or
`modules/DriftField.qml` directly) to override any of these properties:

| Property           | Default | Description                                   |
|---------------------|---------|------------------------------------------------|
| `streakCount`        | `14`    | Number of drifting neon streaks                |
| `showGrid`           | `true`  | Show the fading horizon grid                   |
| `showHorizonGlow`    | `true`  | Show the pulsing radial glow near the horizon  |
| `speedScale`         | `1.0`   | Multiplies drift/pulse speed (`<1` = slower)   |

Example:

```qml
DriftField {
    anchors.fill: parent
    streakCount: 20
    speedScale: 0.6
}
```

## Status

This configuration was authored against documented Quickshell/QtQuick
conventions (`PanelWindow`, `WlrLayershell`, `Variants` over
`Quickshell.screens`, `FileView`, `QtQuick.Effects.MultiEffect`) but has
**not been run against a live Quickshell/Wayland session** in this
environment. If a property name has drifted in your Quickshell version,
`qs -c neon-drift` will tell you exactly which one — please open an issue
or PR with the fix.

## Credits

Inspired by [bjarneo/quickshell](https://github.com/bjarneo/quickshell),
which pioneered reading the live Omarchy palette from `colors.toml` in a
Quickshell background.

## License

See [LICENSE](LICENSE).
