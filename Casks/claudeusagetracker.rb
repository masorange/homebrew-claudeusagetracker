cask "claudeusagetracker" do
  version "2.0.0"
  sha256 "490eb60caca03b392992f6ae5274362eee87d3ca2db6e4cdd2b9c19b125c2b50"

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

      🆕 New in v2.0.0: data now comes from AI Platform
      (ai-platform.cloud.masorange.es). Click the 💰 icon in the menu bar
      and sign in once with your corporate account (SSO). New Models tab
      with every available model, its vendor logo and current price.

      The app should open automatically. If it doesn't, launch it manually:
        open -a "Claude Usage Tracker"
    EOS
  end

  zap trash: [
    "~/Library/Preferences/com.claudeusage.tracker.plist",
  ]
end
