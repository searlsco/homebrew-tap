class Scrapple < Formula
  desc "Local Apple Developer Documentation scraper and search tool"
  homepage "https://github.com/searlsco/scrapple"
  url "https://github.com/searlsco/scrapple/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "407b6e5c2140627d2904576ee438bd312974ab640133ab394b618860fadc0b92"
  license "MIT"

  depends_on "python" => :build
  depends_on "node"
  depends_on "vips"

  def install
    # Use system vips instead of downloading prebuilt sharp binaries
    ENV["SHARP_IGNORE_GLOBAL_LIBVIPS"] = "0"
    ENV["npm_config_sharp_libvips_local_prebuilds"] = "0"

    system "npm", "install", *std_npm_args, "--omit=dev", "--ignore-scripts=false", "--foreground-scripts"
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
