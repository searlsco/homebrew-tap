class Turbocommit < Formula
  desc "Auto-commit after every Claude Code turn"
  homepage "https://github.com/searlsco/turbocommit"
  url "https://github.com/searlsco/turbocommit/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "2cfc3b6b5e6e711d81dfc0b98ae2f1e34f0fcfac550acba38d36a236f1f63257"
  license "MIT"
  head "https://github.com/searlsco/turbocommit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "node"

  def install
    libexec.install Dir["*"]
    (bin/"turbocommit").write_env_script libexec/"cli.js", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  def caveats
    <<~EOS
      To complete installation, run:
        turbocommit install

      This will set up the Stop hook in ~/.claude/settings.json

      To enable in a project, run from the repo root:
        turbocommit init
    EOS
  end

  test do
    system bin/"turbocommit", "--version"
  end
end
