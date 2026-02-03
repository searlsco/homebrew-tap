class ProveIt < Formula
  desc "Verifiability-first hooks for Claude Code - enforce test-gated workflows"
  homepage "https://github.com/searlsco/prove_it"
  url "https://github.com/searlsco/prove_it/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "efa8e6337153ac7c3db750d2ce7728512bb2702a93c24d378490c278ce4325f1"
  license "MIT"
  head "https://github.com/searlsco/prove_it.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "node"

  def install
    libexec.install Dir["*"]
    (bin/"prove_it").write_env_script libexec/"cli.js", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  def caveats
    <<~EOS
      To complete installation, run:
        prove_it install

      This will set up the global hooks in ~/.claude/

      To initialize a project, run from the repo root:
        prove_it init
    EOS
  end

  test do
    system bin/"prove_it", "diagnose"
  end
end
