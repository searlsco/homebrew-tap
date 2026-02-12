class Scrapple < Formula
  desc "Local Apple Developer Documentation scraper and search tool"
  homepage "https://github.com/searlsco/scrapple"
  url "https://github.com/searlsco/scrapple/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "7982624f5ee3832e949be19c84a43e2ccf7f82ce377ee207250c0c2e2b51a672"
  license "MIT"

  depends_on "python" => :build
  depends_on "node"

  def install
    # Install without running lifecycle scripts (avoids sharp native build —
    # scrapple only uses @xenova/transformers for text embeddings, not images)
    system "npm", "install", *std_npm_args, "--omit=dev", "--ignore-scripts"

    # Rebuild only the native modules we actually need
    cd libexec/"lib/node_modules/scrapple" do
      system "npm", "rebuild", "better-sqlite3"
    end

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
    EOS
  end

  test do
    assert_match "Local Apple Developer Documentation", shell_output("#{bin}/scrapple --help")
    # Verify native modules load correctly - exits 0 with JSON output
    output = shell_output("#{bin}/scrapple status")
    assert_match "total", output
  end
end
