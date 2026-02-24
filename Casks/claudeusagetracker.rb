cask "claudeusagetracker" do
  version "1.12.0"
  sha256 "aa3d2abe514bce28810fc7ce9a6f568e85d9413ab769aa16b1dabe06ff415ac6"

  url "https://github.com/masorange/ClaudeUsageTracker/releases/download/v#{version}/ClaudeUsageTracker-v#{version}.dmg"
  name "Claude Usage Tracker"
  desc "Track your Claude Code API usage from your macOS menu bar"
  homepage "https://github.com/masorange/ClaudeUsageTracker"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "ClaudeUsageTracker.app"

  # Gracefully quit the app before uninstall/upgrade (won't fail if app is not running)
  uninstall quit: "com.claudeusage.tracker"

  postflight do
    # Remove quarantine attributes (ignore errors if already removed)
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/ClaudeUsageTracker.app"],
                   sudo: false,
                   print_stderr: false

    # Wait for app to be fully installed and ready
    sleep 1

    # Open using full path (more reliable than app name)
    app_path = "#{appdir}/ClaudeUsageTracker.app"
    if File.exist?(app_path)
      system_command "/usr/bin/open",
                     args: [app_path],
                     sudo: false,
                     print_stderr: false
    end
  end

  caveats do
    <<~EOS
      Claude Usage Tracker has been updated to v#{version}!

      🆕 New in v1.12.0: Accurate Vertex AI Regional Pricing
      - Fixed cache pricing multipliers (creation & read)
      - Applied Vertex AI Regional 1.1x premium to all Claude models
      - Added Claude Sonnet 4.6 and Opus 4.6 support

      The app should open automatically. If it doesn't, launch it manually:
        open -a "Claude Usage Tracker"

      The app runs in your menu bar. Look for the 💰 icon.
    EOS
  end

  zap trash: [
    "~/Library/Preferences/com.claudeusage.tracker.plist",
  ]
end
