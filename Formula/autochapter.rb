class Autochapter < Formula
  desc "Automatically add podcast chapters by detecting stereo audio stingers"
  homepage "https://github.com/searlsco/autochapter"
  url "https://github.com/searlsco/autochapter/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "90110f42649bbd9aec90a3d8e62d785fd154ca886ee4cdcd2e6f41020b4cf5a2"
  license "MIT"

  depends_on "ffmpeg"
  uses_from_macos "python"

  def install
    system "make"
    bin.install "bin/autochapter"
    libexec.install "libexec/autochapter-detect"
  end

  test do
    system "#{bin}/autochapter", "--help"
  end
end
