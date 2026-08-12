# quickshell-neon-drift

**NEON DRIFT — Outrun** ist ein komplettes, self-contained Retro-Racer im
Synthwave-Look: ein einziges `index.html`, das per WebGL eine endlose,
prozedural erzeugte Küstenstraße rendert (Sonnenuntergangs-Sky mit
Skyline-Parallaxe, Rumble-Strips, driftende Rivalen-Autos, Boost/Nitro,
Schadensmodell mit Explosion, Partikel/Funken, CRT-Post-Processing mit
Bloom/Chromatic-Aberration/Scanlines) und komplett synthetisierten Sound
über die Web Audio API (Motor, Synthwave-Sequencer, SFX) — keine externen
Assets, keine Abhängigkeiten außer einer Google-Fonts-Einbindung.

Bedienung:
- **Touch/Maus**: linke/rechte Bildschirmhälfte gedrückt halten zum Lenken
- **NEIGEN**-Button: Lenkung per Gerätesensor (`deviceorientation`)
- **BOOST**-Button bzw. Shift/Pfeil-hoch: Nitro
- Pfeiltasten/`a`/`d` zum Lenken, `m` zum Stummschalten (Desktop)

Es gibt einen Attract-Mode (Titel-Demo mit KI-Fahrer), Checkpoints (geben
Zeit + reparieren die Hülle), ein Schadenssystem (Crash → Explosion →
Game-Over) und eine Bestenliste (Distanz, unfallfreie Strecke, Top-Speed)
im `localStorage`-losen Session-Speicher.

## Ausführen

Einfach `index.html` in einem aktuellen Browser mit WebGL-Unterstützung
öffnen:

```sh
open index.html        # macOS
xdg-open index.html    # Linux
```

Für den Geräteneigungssensor (`NEIGEN`) auf Mobilgeräten verlangen iOS/Android
in der Regel HTTPS oder `localhost` — dafür lokal z. B. servieren mit:

```sh
python3 -m http.server 8080
# dann http://localhost:8080 öffnen
```

## Struktur

Ein einziges File `index.html` — HTML, CSS und das komplette Spiel
(WebGL-Renderer, Audio-Engine, Input-Handling, Game-Loop) liegen inline im
`<script>`-Tag. Bewusst ohne Build-Step, ohne Bundler, ohne externe
JS-Bibliotheken.

## License

See [LICENSE](LICENSE).
