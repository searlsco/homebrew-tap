class Scrapple < Formula
  desc "Local Apple Developer Documentation scraper and search tool"
  homepage "https://github.com/searlsco/scrapple"
  url "https://github.com/searlsco/scrapple/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "fb712f97aef0b19a589522902b480b4d56637f1fa3daa000c68fd53591c61cdd"
  license "MIT"

  depends_on "python" => :build
  depends_on "node"

  def install
    # Enable scripts for native module compilation (better-sqlite3, sqlite-vec)
    system "npm", "install", *std_npm_args, "--omit=dev", "--ignore-scripts=false"
    libexec.install Dir["*"]

    (bin/"scrapple").write <<~SH
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/lib/node_modules/scrapple/dist/cli.js" "$@"
    SH
  end

  def caveats
    <<~EOS
      Scrapple uses Playwright for WWDC transcript extraction.
      On first sync, Playwright will download Chromium (~150MB).

      To pre-install the browser:
        npx playwright install chromium

      To sync Apple documentation:
        scrapple sync --human

      Note: Semantic search is temporarily disabled while dependency
      issues are resolved. Keyword search works normally.
    EOS
  end

  test do
    assert_match "Local Apple Developer Documentation", shell_output("#{bin}/scrapple --help")
    # Verify native modules load correctly - exits 0 with JSON output
    output = shell_output("#{bin}/scrapple status")
    assert_match "total", output
  end
end
