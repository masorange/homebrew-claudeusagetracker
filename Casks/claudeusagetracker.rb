cask "claudeusagetracker" do
  version "1.4.0"
  sha256 "ab816e18c0c09f72b5258ee4d445df1e69b52d16000acde7dce33c06a8f528c1"

  url "https://github.com/masorange/ClaudeUsageTracker/releases/download/v#{version}/ClaudeUsageTracker-v#{version}.dmg"
  name "Claude Usage Tracker"
  desc "Track your Claude Code API usage from your macOS menu bar"
  homepage "https://github.com/masorange/ClaudeUsageTracker"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "ClaudeUsageTracker.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/ClaudeUsageTracker.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Preferences/com.claudeusage.tracker.plist",
  ]
end
