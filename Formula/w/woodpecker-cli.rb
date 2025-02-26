class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "0bdc1f321cdd89e6781694913eea012d378ab36085ededa7487cc51a7b07f50d"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15223fd4ce2e74a88d96feaedb47d4f6a101423340fad8533d482c38eecc7849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15223fd4ce2e74a88d96feaedb47d4f6a101423340fad8533d482c38eecc7849"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15223fd4ce2e74a88d96feaedb47d4f6a101423340fad8533d482c38eecc7849"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdfe9e97f5a6f468896d834ace51e55b27a0ecdd09916aa3d781dcd4b7203b54"
    sha256 cellar: :any_skip_relocation, ventura:       "bdfe9e97f5a6f468896d834ace51e55b27a0ecdd09916aa3d781dcd4b7203b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da48c40a761f6d61fe4283b92ecdea999a17547570071c0c66cd3fd3ff93b1d9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end
