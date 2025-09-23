class Autochapter < Formula
  desc "Automatically add podcast chapters by detecting stereo audio stingers"
  homepage "https://github.com/searlsco/autochapter"
  url "https://github.com/searlsco/autochapter/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "acc1e2cfb5bf454243626c5b7d38fa70b5f38ba89b04b06340b044f7ebe3cda2"
  license "MIT"

  depends_on "ffmpeg"
  uses_from_macos "python"

  def install
    bin.install "bin/autochapter"
  end

  test do
    system "#{bin}/autochapter", "--help"
  end
end
