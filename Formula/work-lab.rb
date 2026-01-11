# typed: false
# frozen_string_literal: true

class WorkLab < Formula
  desc "Container-based lab for humans and AI coding agents"
  homepage "https://github.com/modern-tooling/work-lab"
  url "https://github.com/modern-tooling/work-lab/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "fca5ab1237e5ac49ac1ad3994d1cb24b69125f3a88a25aed5f60af9b2e1bad8b"
  license "MIT"

  depends_on "docker" => :recommended

  def install
    # Install the main script
    bin.install "bin/work-lab"

    # Install the library
    (libexec/"lib").install Dir["lib/*.sh"]

    # Install devcontainer configuration
    (libexec/".devcontainer").install Dir[".devcontainer/*"]

    # Patch the script to find the lib in the correct location
    inreplace bin/"work-lab", 'readonly REPO_DIR="$(dirname -- "$SCRIPT_DIR")"', "readonly REPO_DIR=\"#{libexec}\""
  end

  def caveats
    <<~EOS
      work-lab requires Docker and the devcontainer CLI.

      Install the devcontainer CLI:
        npm install -g @devcontainers/cli

      Quick start:
        cd /path/to/your/project
        work-lab doctor
        work-lab start
        work-lab mux
    EOS
  end

  test do
    assert_match "work-lab #{version}", shell_output("#{bin}/work-lab version")
  end
end
