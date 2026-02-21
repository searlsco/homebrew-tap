class Turbocommit < Formula
  desc "Auto-commit after every Claude Code turn"
  homepage "https://github.com/searlsco/turbocommit"
  url "https://github.com/searlsco/turbocommit/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "3b5181694f05c7f527905693807ea0b669bc07a8553d1abf6332b0910d49a3c4"
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
