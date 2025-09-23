class Autochapter < Formula
  desc "Automatically add podcast chapters by detecting stereo audio stingers"
  homepage "https://github.com/searlsco/autochapter"
  url "https://github.com/searlsco/autochapter/archive/refs/tags/v0.0.0.tar.gz"
  sha256 "REPLACE_WITH_REAL_SHA256"
  license "MIT"

  depends_on "ffmpeg"
  uses_from_macos "python" => :run

  def install
    bin.install "bin/autochapter"
  end

  test do
    system "#{bin}/autochapter", "--help"
  end
end
