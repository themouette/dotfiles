Pi
===

Configuration for [pi](https://pi.dev), the coding agent.

Run `./install pi-dev` to link the configuration into `~/.pi/agent/`:

- `pi/settings.json` → `~/.pi/agent/settings.json`
- `pi/mcp.json` → `~/.pi/agent/mcp.json`
- `pi/session-cost.json` → `~/.pi/agent/session-cost.json` (only when `DATADOG_ROOT` is set)

Note: `models.json` and `extensions/` are machine-local and intentionally not
synced or published.
