class Thingy < Formula
  desc "JSON command-line interface to Things 3"
  homepage "https://github.com/searlsco/thingy"
  url "https://github.com/searlsco/thingy/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "438be05ae44ca522072bac99afb1ca6e3e5ecfa641ae6ffa4e2dcc4a2846f08f"
  license "MIT"
  head "https://github.com/searlsco/thingy.git", branch: "main"

  depends_on :macos

  def install
    libexec.install "bin", "lib", "VERSION"
    bin.write_exec_script libexec/"bin/thingy"
  end

  def caveats
    <<~EOS
      Requires Things 3 and permission for the calling application to automate it.
      Data commands must run in the signed-in user's session.
    EOS
  end

  test do
    assert_match "thingy #{version}", shell_output("#{bin}/thingy --version")
    assert_match "thingy apply ID", shell_output("#{bin}/thingy help")
  end
end
