class ProveIt < Formula
  desc "Config-driven hook framework for Claude Code - enforce verified workflows"
  homepage "https://github.com/searlsco/prove_it"
  url "https://github.com/searlsco/prove_it/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "d485a2a5c3627b22310caf0280e033127a4f98c0546ac9748a5f29df50b094da"
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

      This registers global hooks in ~/.claude/
      Re-run after every upgrade to keep hooks current.

      To initialize a project, run from the repo root:
        prove_it init
    EOS
  end

  test do
    system bin/"prove_it", "diagnose"
  end
end
