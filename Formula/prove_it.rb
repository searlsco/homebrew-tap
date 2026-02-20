class ProveIt < Formula
  desc "Config-driven hook framework for Claude Code - enforce verified workflows"
  homepage "https://github.com/searlsco/prove_it"
  url "https://github.com/searlsco/prove_it/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "e1160ee5361ad68556fdecef006babb1fdbffbf6a65d4e4a3518317a33e65336"
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
