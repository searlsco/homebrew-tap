class Imsg < Formula
  desc "Export your iMessages into a portable web archive"
  homepage "https://github.com/searlsco/imsg"
  url "https://github.com/searlsco/imsg/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "e9166c70bfb90ae38c00c3ee042af8d2a9443d06afaeaf25a202ee8d66d1ca04"
  license "MIT"
  head "https://github.com/searlsco/imsg.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "ruby@3"
  depends_on "sqlite"

  def install
    # Ensure Bundler uses brewed Ruby during build
    ENV.prepend_path "PATH", Formula["ruby@3"].opt_bin

    # Keep project tree intact so require_relative works
    libexec.install Dir["*"]

    # Ensure the repo-provided executable exists and is executable
    app_exec = libexec/"bin/imsg"
    app_exec.chmod 0755 if app_exec.exist?

    # Vendor gems under libexec so the keg is self-contained
    ENV["BUNDLE_PATH"] = (libexec/"vendor/bundle").to_s
    ENV["BUNDLE_WITHOUT"] = "development:test"
    ENV["BUNDLE_BIN"] = (libexec/"bin").to_s

    ENV["bundle_build__sqlite3"] = "--with-sqlite3-dir=#{Formula["sqlite"].opt_prefix}"

    cd libexec do
      system "bundle", "config", "set", "path", ENV["BUNDLE_PATH"]
      system "bundle", "config", "set", "without", ENV["BUNDLE_WITHOUT"]
      system "bundle", "config", "set", "bin", ENV["BUNDLE_BIN"]
      system "bundle", "install"

      # Remove build-time artifacts that may embed Homebrew shims paths (audit-clean)
      rm Dir[libexec/"vendor/bundle/**/ext/**/{mkmf.log,config.log}"]
      rm_r Dir[libexec/"vendor/bundle/**/ext/**/tmp"]
      rm_r Dir[libexec/"vendor/bundle/**/cache"]
    end

    # Create a wrapper in bin/ that sets up env and calls the repo's bin/imsg
    env = {
      GEM_HOME:       ENV["BUNDLE_PATH"],
      GEM_PATH:       ENV["BUNDLE_PATH"],
      BUNDLE_GEMFILE: (libexec/"Gemfile").to_s,
      RUBYLIB:        (libexec/"lib").to_s,
      PATH:           "#{Formula["ruby@3"].opt_bin}:$PATH",
    }
    # Always write the wrapper so Homebrew links a real executable under keg/bin
    (bin/"imsg").write_env_script libexec/"bin/imsg", env
  end

  test do
    output = shell_output("#{bin}/#{name} --help")
    assert_match "imsg export [options]", output
  end
end
