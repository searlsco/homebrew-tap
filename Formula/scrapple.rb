class Scrapple < Formula
  desc "Local Apple Developer Documentation scraper and search tool"
  homepage "https://github.com/searlsco/scrapple"
  url "https://github.com/searlsco/scrapple/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "4a8cd21d18501ebab4460b3c57d233fa849e9df0efe1f26b8f4075fbc2dd1c86"
  license "MIT"

  depends_on "node@20"
  uses_from_macos "python" => :build

  def install
    system "npm", "install", *std_npm_args
    system "npm", "run", "build"

    libexec.install "dist", "node_modules", "package.json"

    (bin/"scrapple").write <<~SH
      #!/bin/bash
      exec "#{Formula["node@20"].opt_bin}/node" "#{libexec}/dist/cli.js" "$@"
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
  end
end
