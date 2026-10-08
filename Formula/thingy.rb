class Thingy < Formula
  desc "JSON command-line interface to Things 3"
  homepage "https://github.com/searlsco/thingy"
  url "https://github.com/searlsco/thingy/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "852c0df701fc1c4c5f873be46485d2559d02578b206e3af830b698520f1f6b6b"
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
