#!/bin/bash
# Installs or updates Claude Usage Tracker with Homebrew.
#
#   curl -fsSL https://raw.githubusercontent.com/masorange/homebrew-claudeusagetracker/main/install.sh | bash
#
# Safe to run any number of times: it installs the app if missing, upgrades it if outdated, and moves
# installations made from the legacy taps (masmovil/…, SergioBanuls/…) to masorange/claudeusagetracker.
# Your settings and sign-in are kept (they live in ~/Library, not in the app bundle).
set -euo pipefail

# Everything runs inside main() so that, when piped from curl, bash reads the whole script before executing it.
main() {
  TAP="masorange/claudeusagetracker"
  CASK="$TAP/claudeusagetracker"
  LEGACY_TAPS=("masmovil/claudeusagetracker" "sergiobanuls/claudeusagetracker")

  info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
  fail() { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

  [[ "$(uname -s)" == "Darwin" ]] || fail "Claude Usage Tracker only runs on macOS."
  major=$(sw_vers -productVersion | cut -d. -f1)
  (( major >= 13 )) || fail "macOS 13 (Ventura) or later is required (you have $(sw_vers -productVersion))."

  if ! command -v brew >/dev/null 2>&1; then
    for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      [[ -x "$candidate" ]] && eval "$("$candidate" shellenv)" && break
    done
  fi
  command -v brew >/dev/null 2>&1 || fail "Homebrew is not installed. Install it from https://brew.sh and run this again."

  # Tap that the current installation came from (empty if not installed).
  installed_from() {
    local receipt
    receipt="$(brew --prefix)/Caskroom/claudeusagetracker/.metadata/INSTALL_RECEIPT.json"
    [[ -f "$receipt" ]] || return 0
    /usr/bin/plutil -extract source.tap raw -o - "$receipt" 2>/dev/null | tr '[:upper:]' '[:lower:]' || true
  }

  info "Updating Homebrew…"
  # Also refreshes the legacy taps: the old personal tap now ships a migration instead of a cask.
  brew update --quiet </dev/null >/dev/null 2>&1 || true
  brew tap "$TAP" >/dev/null 2>&1

  origin="$(installed_from)"
  for legacy in "${LEGACY_TAPS[@]}"; do
    brew tap | grep -qix "$legacy" || continue
    # Homebrew 7 refuses to load casks from untrusted taps, and uninstall/untap need to load them.
    brew trust --cask "${legacy}/claudeusagetracker" >/dev/null 2>&1 || true
    if [[ "$origin" == "$legacy" ]]; then
      info "Moving Claude Usage Tracker from the old tap ${legacy} to ${TAP} (your settings are kept)…"
      brew uninstall --cask --force "${legacy}/claudeusagetracker" >/dev/null 2>&1 || true
      origin=""
    fi
    info "Removing the old tap ${legacy}…"
    brew untap "$legacy" >/dev/null 2>&1 || brew untap --force "$legacy" >/dev/null 2>&1 \
      || printf 'Warning: could not remove %s; run `brew untap %s` later.\n' "$legacy" "$legacy" >&2
  done

  if [[ -n "$origin" ]] || brew list --cask claudeusagetracker >/dev/null 2>&1; then
    if [[ -n "$(brew outdated --cask "$CASK" 2>/dev/null)" ]]; then
      info "Updating Claude Usage Tracker…"
      brew upgrade --cask "$CASK" </dev/null
    else
      info "Claude Usage Tracker is already up to date."
    fi
  elif [[ -d "/Applications/ClaudeUsageTracker.app" ]]; then
    info "Replacing the manually installed app with the Homebrew one (your settings are kept)…"
    brew install --cask --force "$CASK" </dev/null
  else
    info "Installing Claude Usage Tracker…"
    brew install --cask "$CASK" </dev/null
  fi

  # Homebrew sandboxes cask install steps and won't launch apps, so open it from here.
  /usr/bin/open -a ClaudeUsageTracker >/dev/null 2>&1 || true

  version="$(brew list --cask --versions claudeusagetracker 2>/dev/null | awk '{print $2}')"
  info "Claude Usage Tracker ${version:-} is ready. Click the 💰 icon in the menu bar."
}

main "$@"
