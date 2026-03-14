class ProveIt < Formula
  desc "Config-driven hook framework for Claude Code - enforce verified workflows"
  homepage "https://github.com/searlsco/prove_it"
  url "https://github.com/searlsco/prove_it/archive/refs/tags/v0.64.1.tar.gz"
  sha256 "1deb79ba84bea517a045ada554cea1cf1a3dfed6d6f1dc7e3bfab4b951001495"
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
