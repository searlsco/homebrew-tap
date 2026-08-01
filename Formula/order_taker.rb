class OrderTaker < Formula
  desc "GitHub-driven agent sessions: issues in, PRs out, via Claude Code or Codex"
  homepage "https://github.com/searlsco/order_taker"
  url "https://github.com/searlsco/order_taker/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b0ca4ac2295566a82fda17261c3d2ec7d6f77f8fd31762d480cb51049ee2b2dc"
  license "MIT"
  head "https://github.com/searlsco/order_taker.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "gh"
  depends_on "ruby@3"

  def install
    libexec.install Dir["*"]
    (bin/"order_taker").write_env_script libexec/"bin/order_taker", PATH: "#{formula_opt_bin("ruby@3")}:$PATH"
  end

  def caveats
    <<~EOS
      To get started:
        order_taker init      # write an example config, then edit it
        order_taker install   # install and load the launchd agent

      Requires gh to be authenticated (ideally as a bot account) and
      claude and/or codex on your PATH.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/order_taker version")
  end
end
