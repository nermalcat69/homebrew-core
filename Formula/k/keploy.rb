class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https://keploy.io"
  url "https://github.com/keploy/keploy/archive/refs/tags/v2.4.8.tar.gz"
  sha256 "34be646c1decaf8e054a316abedf4a5857878a4ab3e25f96a0bfc6db2948e88d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2708b6d2da07e6c410af913d2f6aad5144601280ecfb71b72fcc5cea19ba743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2708b6d2da07e6c410af913d2f6aad5144601280ecfb71b72fcc5cea19ba743"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2708b6d2da07e6c410af913d2f6aad5144601280ecfb71b72fcc5cea19ba743"
    sha256 cellar: :any_skip_relocation, sonoma:        "c45ec05b67f10b17a1baaa48c69ef74dff80be6705038f98f0463e83151221e0"
    sha256 cellar: :any_skip_relocation, ventura:       "c45ec05b67f10b17a1baaa48c69ef74dff80be6705038f98f0463e83151221e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9794f4ae8d80afd25e68b2f7ad266a7df7d6f8790a7efb3fd59c47052eaac96"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    system bin/"keploy", "config", "--generate", "--path", testpath
    assert_match "# Generated by Keploy", (testpath/"keploy.yml").read

    output = shell_output("#{bin}/keploy templatize --path #{testpath}")
    assert_match "No test sets found to templatize", output

    assert_match version.to_s, shell_output("#{bin}/keploy --version")
  end
end
