class Imsg < Formula
  desc "Export your iMessages into a portable web archive"
  homepage "https://github.com/searlsco/imsg"
  url "https://github.com/searlsco/imsg/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "e63de2f5b3707ffe37ac3fd8cb55720f2e382320ceeb5274f307d219c0882148"
  license "MIT"
  head "https://github.com/searlsco/imsg.git", branch: "main"

  depends_on "ruby@3"

  def install
    # Ensure Bundler runs with brewed Ruby at build time
    ENV.prepend_path "PATH", Formula["ruby@3"].opt_bin

    # Keep project tree intact so `require_relative '../lib/...'` works.
    libexec.install Dir["*"]

    cd libexec do
      system "bundle", "config", "set", "path", libexec
      system "bundle", "config", "set", "without", "development test"
      system "bundle", "install"
    end

    ruby = Formula["ruby@3"].opt_bin/"ruby"

    # Rewrite shebang to brew-ruby. See how this is done for python formulae:
    #   - https://rubydoc.brew.sh/Utils/Shebang.html#rewrite_shebang-class_method
    #   - https://rubydoc.brew.sh/Language/Python/Shebang.html#detected_python_shebang-class_method
    inreplace libexec/"bin/#{name}", %r{^#!.*ruby( |$)}, "#!#{ruby}\\1"

    # Expose the rewritten script (no PATH tricks needed now)
    bin.write_exec_script libexec/"bin/#{name}"
  end

  test do
    output = shell_output("#{bin}/#{name} --help")
    assert_match "imsg export [options]", output
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end
end
