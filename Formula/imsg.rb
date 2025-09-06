class Imsg < Formula
  desc "Export your iMessages into a portable web archive"
  homepage "https://github.com/searlsco/imsg"
  url "https://github.com/searlsco/imsg/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "e63de2f5b3707ffe37ac3fd8cb55720f2e382320ceeb5274f307d219c0882148"
  license "MIT"
  head "https://github.com/searlsco/imsg.git", branch: "main"

  depends_on "ruby@3"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test imsg`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "false"
  end
end
