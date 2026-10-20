class GlazeAgainstTheMachine < Formula
  desc "Rewrite frustrated prompts before they reach a coding agent"
  homepage "https://github.com/searlsco/glaze_against_the_machine"
  url "https://github.com/searlsco/glaze_against_the_machine/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "9917d5689fd448d9e9a9e4501d947942ad9ddde7d514fc3abb8c728cfa180592"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "ci", *std_npm_args(prefix: false), "--omit=dev"
    libexec.install "bin", "src", "hooks", ".claude-plugin", "package.json", "package-lock.json", "node_modules"
    (bin/"glaze_against_the_machine").write_env_script libexec/"bin/glaze_against_the_machine.js",
      PATH:                           "#{formula_opt_bin("node")}:$PATH",
      GLAZE_AGAINST_THE_MACHINE_ROOT: opt_libexec,
      GLAZE_AGAINST_THE_MACHINE_NODE: formula_opt_bin("node")/"node"
  end

  def caveats
    <<~EOS
      Enable an integration with an installed, signed-in coding agent:
        glaze_against_the_machine install claude
        glaze_against_the_machine install codex
        glaze_against_the_machine install paseo
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/glaze_against_the_machine --version").strip
    assert_path_exists libexec/".claude-plugin/plugin.json"
    assert_path_exists libexec/".claude-plugin/marketplace.json"
    assert_path_exists libexec/"hooks/register.js"
    prompt = "rawdog Leave this prompt unchanged."
    assert_equal prompt, pipe_output("#{bin}/glaze_against_the_machine", prompt, 0)
    envelope = { "prompt" => prompt, "session_id" => "homebrew-test" }
    output = pipe_output("#{bin}/glaze_against_the_machine --json", envelope.to_json, 0)
    assert_equal envelope, JSON.parse(output)
  end
end
