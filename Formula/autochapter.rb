class Autochapter < Formula
  desc "Automatically add podcast chapters by detecting stereo audio stingers"
  homepage "https://github.com/searlsco/autochapter"
  url "https://github.com/searlsco/autochapter/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "67182a73ac087039aa572ff2b9a2e851a00c3d0dc653534c2da818b17f2367fb"
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
