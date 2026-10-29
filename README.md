# Set agy to auto mode (high-auto)

One-shot PowerShell script that sets Antigravity CLI (`agy`) **Agent Mode** to `auto`.

## Copy-paste in PowerShell

```powershell
irm https://raw.githubusercontent.com/SecureMindkym/agy-auto-mode/main/set-agy-auto.ps1 | iex
```

Or clone / download `set-agy-auto.ps1` and run:

```powershell
.\set-agy-auto.ps1
```

## What it does

Writes `"agentMode": "auto"` into:

`%USERPROFILE%\.gemini\antigravity-cli\settings.json`

Existing settings are kept; only `agentMode` is set/updated.

## After running

1. Close open `agy` sessions  
2. Start `agy` again  
3. Confirm the bottom-right status shows **auto** (or press **Shift+Tab** to cycle)

## Requirements

- Antigravity CLI **v1.4.4+** on Windows  
- Terminal sandbox: **Windows 11 24H2** (Aug 2026 update or later)  
- Not available on business/enterprise Antigravity accounts  

Docs: [Choose an execution mode](https://antigravity.google/docs/cli/modes/)

Dated: 29 Oct 2026 NZDT — re-check against the wiki/live system if this is more than 2 weeks old.
