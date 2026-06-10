class Scrapple < Formula
  desc "Local Apple Developer Documentation scraper and search tool"
  homepage "https://github.com/searlsco/scrapple"
  url "https://github.com/searlsco/scrapple/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "ed171aec9fe7916a0a092494e063b6c9eb77eb006d1c35f0c6aa36ca20c4fcf8"
  license "MIT"

  depends_on "python" => :build
  depends_on "node"

  def install
    # Install without running lifecycle scripts (avoids sharp native build —
    # scrapple only uses @xenova/transformers for text embeddings, not images)
    system "npm", "install", *std_npm_args, "--omit=dev"

    # Replace the real sharp with our stub — scrapple never uses image processing
    pkg_root = libexec/"lib/node_modules/scrapple"
    sharp_dir = pkg_root/"node_modules/@xenova/transformers/node_modules/sharp"
    if sharp_dir.exist?
      rm_r sharp_dir
      cp_r pkg_root/"stubs/sharp", sharp_dir
    end

    # Rebuild only the native modules we actually need
    cd pkg_root do
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
