# Homebrew Tap for Claude Usage Tracker

[Claude Usage Tracker](https://github.com/masorange/ClaudeUsageTracker) shows your MasOrange AI spend, budget and
available models in the macOS menu bar.

## Install or update (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/masorange/homebrew-claudeusagetracker/main/install.sh | bash
```

The same command installs the app, updates it to the latest version, and fixes old installations made from the
previous taps (`masmovil/…`, `SergioBanuls/…`). Your settings and sign-in are kept. The app opens when it finishes:
click the **💰** icon in the menu bar and sign in once with your MasOrange account (SSO).

Requirements: macOS 13 (Ventura) or later and [Homebrew](https://brew.sh).

## Prefer plain Homebrew commands?

```bash
# Install
brew install --cask masorange/claudeusagetracker/claudeusagetracker
open -a ClaudeUsageTracker

# Update
brew update && brew upgrade --cask masorange/claudeusagetracker/claudeusagetracker

# Uninstall (add --zap to also remove settings, cache and sign-in data)
brew uninstall --cask claudeusagetracker
```

## Troubleshooting

| Message | Fix |
|---|---|
| `Cask claudeusagetracker exists in multiple taps` | You still have an old tap. Run the one-command installer above, or `brew untap masmovil/claudeusagetracker`. |
| `"ClaudeUsageTracker" is damaged and can't be opened` | Run `xattr -cr /Applications/ClaudeUsageTracker.app` and open it again. |
| `It seems there is already an App at '/Applications/ClaudeUsageTracker.app'` | It was installed by hand from the DMG. The one-command installer replaces it, or use `brew install --cask --force …`. |
| The menu bar shows `💰 ⚠︎` | Your corporate session expired: click the icon and press **Sign in**. |

## License

Personal Use License (Non-Commercial) - See [LICENSE](https://github.com/masorange/ClaudeUsageTracker/blob/main/LICENSE)

Copyright (c) 2025 Sergio Bañuls. This software is licensed for personal, non-commercial use only. Commercial use requires prior written permission from the copyright holder.
