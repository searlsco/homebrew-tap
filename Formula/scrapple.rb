class Scrapple < Formula
  desc "Local Apple Developer Documentation scraper and search tool"
  homepage "https://github.com/searlsco/scrapple"
  url "https://github.com/searlsco/scrapple/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "eb46a951ea738a66805bb3dc70ad0b8583abf7bca18919823ef49549bf18a524"
  license "MIT"

  depends_on "python" => :build
  depends_on "node"

  def install
    # Install in-tree against the lockfile instead of Homebrew's default
    # pack-then-global-install. package.json lists @huggingface/transformers in
    # bundleDependencies, so `npm pack` on a clean checkout emits a tarball that
    # claims to bundle it while shipping nothing; installing that tarball makes
    # npm skip the registry fetch and drop the dependency, exit 0, no warning.
    # `npm ci` also applies the overrides entry pointing sharp at stubs/sharp,
    # which the global install drops -- transformers statically imports sharp at
    # load time, and the stub satisfies that without ~16MB of @img/* binaries.
    system "npm", "ci", *std_npm_args(prefix: false), "--omit=dev"

    # Lifecycle scripts are skipped above, so build the one native module we need
    system "npm", "rebuild", "better-sqlite3"

    # node_modules/sharp is a relative symlink to ../stubs/sharp, so it stays
    # valid as long as stubs/ travels with the tree
    libexec.install Dir["*"]

    (bin/"scrapple").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/dist/cli.js" "$@"
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
