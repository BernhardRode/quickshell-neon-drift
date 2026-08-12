pragma Singleton
import QtQuick
import Quickshell.Io

// Reads Omarchy's live theme palette (~/.config/omarchy/current/theme/colors.toml)
// and exposes it as a small set of QML properties. Falls back to a built-in
// neon palette when Omarchy isn't installed, the file is missing, or nothing
// parses, so Neon Drift also looks right stand-alone.
//
// `watchChanges` keeps this in sync whenever `omarchy theme set <name>` swaps
// the active theme, without restarting the shell.
QtObject {
    id: root

    readonly property string fallbackBackground: "#05030a"
    readonly property string fallbackBackgroundAlt: "#0c0818"
    readonly property string fallbackForeground: "#e6e6ff"
    readonly property var fallbackAccents: ["#ff2bd6", "#22e3ff", "#7c3aed", "#39ff88"]

    property string background: fallbackBackground
    property string backgroundAlt: fallbackBackgroundAlt
    property string foreground: fallbackForeground
    property var accents: fallbackAccents

    // Flattened "section.key" -> "#hexvalue" map produced by _parse().
    property var parsed: ({})

    FileView {
        id: colorsFile
        path: "~/.config/omarchy/current/theme/colors.toml"
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root._parse(colorsFile.text)
        onLoadFailed: (error) => {
            console.warn("[neon-drift] could not read Omarchy colors.toml (" + error + "), using fallback palette")
        }
    }

    function _parse(source) {
        if (!source) return

        const map = {}
        let section = ""

        const lines = source.split("\n")
        for (let i = 0; i < lines.length; i++) {
            const line = lines[i].trim()
            if (line.length === 0 || line.startsWith("#")) continue

            const sectionMatch = line.match(/^\[(?:colors\.)?([\w.-]+)\]$/)
            if (sectionMatch) {
                section = sectionMatch[1]
                continue
            }

            const kv = line.match(/^([\w-]+)\s*=\s*['"]?(#?[0-9a-fA-F]{3,8})['"]?/)
            if (kv) {
                const key = section ? section + "." + kv[1] : kv[1]
                let value = kv[2]
                if (!value.startsWith("#")) value = "#" + value
                map[key] = value
            }
        }

        root.parsed = map
        root._apply()
    }

    function _pick() {
        for (let i = 0; i < arguments.length; i++) {
            const value = root.parsed[arguments[i]]
            if (value) return value
        }
        return undefined
    }

    function _apply() {
        root.background = root._pick("primary.background", "background") || root.fallbackBackground
        root.backgroundAlt = root._pick("primary.background_alt", "background_alt", "normal.black") || root.fallbackBackgroundAlt
        root.foreground = root._pick("primary.foreground", "foreground") || root.fallbackForeground

        const found = [
            root._pick("normal.magenta", "bright.magenta", "magenta"),
            root._pick("normal.cyan", "bright.cyan", "cyan"),
            root._pick("normal.blue", "bright.blue", "blue"),
            root._pick("normal.green", "bright.green", "green")
        ].filter((c) => !!c)

        root.accents = found.length > 0 ? found : root.fallbackAccents
    }
}
