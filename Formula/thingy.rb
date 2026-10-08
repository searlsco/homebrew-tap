class Thingy < Formula
  desc "JSON command-line interface to Things 3"
  homepage "https://github.com/searlsco/thingy"
  url "https://github.com/searlsco/thingy/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "443fea7e29cbc106e59f991bbd2342c5f1c75d4169fcb58f82d54d6434f32456"
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
