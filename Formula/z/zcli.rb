class Zcli < Formula
    desc "Zerops command line utility"
    homepage "https://github.com/zeropsio/zcli"
    url "https://github.com/zeropsio/zcli/releases/download/v1.0.42/zcli_1.0.42_darwin_arm64.tar.gz"
    sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  
    bottle do
      sha256 cellar: :any_skip_relocation, arm64_sonoma: "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
      sha256 cellar: :any_skip_relocation, x86_64_linux: "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
    end
  
    depends_on "wireguard-tools"

    def install
      bin.install "zcli"
    end
  end