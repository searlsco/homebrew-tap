class Turbocommit < Formula
  desc "Auto-commit after every Claude Code turn"
  homepage "https://github.com/searlsco/turbocommit"
  url "https://github.com/searlsco/turbocommit/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "5c6e88a03e2366866f98bc081a82b022b1b42a1d62dbe34ce83a44b01f69bfc0"
  license "MIT"
  head "https://github.com/searlsco/turbocommit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "node"

  def install
    libexec.install Dir["*"]
    (bin/"turbocommit").write_env_script libexec/"cli.js", PATH: "#{formula_opt_bin("node")}:$PATH"
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
