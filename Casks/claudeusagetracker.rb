cask "claudeusagetracker" do
  version "2.0.0"
  sha256 "490eb60caca03b392992f6ae5274362eee87d3ca2db6e4cdd2b9c19b125c2b50"

  url "https://github.com/masorange/ClaudeUsageTracker/releases/download/v#{version}/ClaudeUsageTracker-v#{version}.dmg"
  name "Claude Usage Tracker"
  desc "Menu bar app with your MasOrange AI spend, budget and available models"
  homepage "https://github.com/masorange/ClaudeUsageTracker"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "ClaudeUsageTracker.app"

  postflight_steps do
    # The app is ad-hoc signed (not notarised): drop the quarantine flag so Gatekeeper lets it open.
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/ClaudeUsageTracker.app"],
        must_succeed: false,
        print_stderr: false
  end

  uninstall quit: "com.claudeusage.tracker"

  zap trash: [
    "~/Library/Application Support/ClaudeUsageTracker",
    "~/Library/Caches/com.claudeusage.tracker",
    "~/Library/HTTPStorages/com.claudeusage.tracker",
    "~/Library/Preferences/com.claudeusage.tracker.plist",
    "~/Library/WebKit/com.claudeusage.tracker",
  ]

  caveats <<~EOS
    Open it with:  open -a ClaudeUsageTracker
    Then click the 💰 icon in the menu bar and sign in once with your MasOrange account (SSO).
    The Models tab uses your LiteLLM key: detected from Claude Code, or paste it once.
  EOS
end
