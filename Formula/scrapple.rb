class Scrapple < Formula
  desc "Local Apple Developer Documentation scraper and search tool"
  homepage "https://github.com/searlsco/scrapple"
  url "https://github.com/searlsco/scrapple/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "4d1c7369ff5b87ffc065505e237ff88d315352c141b2bf12fc2cf0282ac8e8b5"
  license "MIT"

  depends_on "node"

  def install
    # Install deps locally, then copy to libexec
    system "npm", "install", *std_npm_args, "--omit=dev"
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
    EOS
  end

  test do
    assert_match "Local Apple Developer Documentation", shell_output("#{bin}/scrapple --help")
  end
end
