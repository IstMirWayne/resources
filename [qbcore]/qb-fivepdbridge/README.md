# qb-fivepdbridge

Dieses Script verbindet QBCore mit FivePD. Es stellt sicher, dass nur Spieler mit dem Job `police` Zugriff auf FivePD erhalten.

## Features
- Automatische Jobprüfung beim Einloggen
- Blockiert FivePD für Nicht-Cops
- Custom Befehl: `/fivepdmenu` nur für Polizei

## Installation

1. Lege das Skript in `resources/[local]/qb-fivepdbridge`
2. Füge in deine `server.cfg` folgendes ein:

```
start qb-fivepdbridge
```

3. Stelle sicher, dass `qb-core` und `FivePD` geladen sind.
