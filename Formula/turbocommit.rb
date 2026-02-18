class Turbocommit < Formula
  desc "Auto-commit after every Claude Code turn"
  homepage "https://github.com/searlsco/turbocommit"
  url "https://github.com/searlsco/turbocommit/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4e04c1afdff90de3940f86492c4ba44753e1ef54a1dbd4512f3b5cf2e0196845"
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
