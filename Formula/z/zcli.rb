class Zcli < Formula
    desc "Zerops command line utility"
    homepage "https://github.com/zeropsio/zcli"
    version "1.0.41"
    license "MIT"
  
    if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/zeropsio/zcli/releases/download/v#{version}/zcli-darwin-arm64-npm.tar.gz"
      sha256 "4e7974eb98b3ec34c93f06c61126ae02c4cc249a11a17d9d1e468e9fc1a42ec0"
    elsif OS.mac? && Hardware::CPU.intel?
      url "https://github.com/zeropsio/zcli/releases/download/v#{version}/zcli-darwin-amd64-npm.tar.gz"
      sha256 "07c25ea766415438918e25351065ad2b8d63801230ecb7f1eb21c5aaeaa3735b"
    elsif OS.linux? && Hardware::CPU.intel?
      url "https://github.com/zeropsio/zcli/releases/download/v#{version}/zcli-linux-amd64-npm.tar.gz"
      sha256 "87792136a52c11557d1973c815ffde184d17ba110407e07700a317cc1ceaec1c"
    else
      odie "Unsupported platform for zcli"
    end
  
    livecheck do
      url :stable
      strategy :github_latest
    end
  
    def install
      bin.install "zcli"
    end
  
    test do
      assert_match version.to_s, shell_output("#{bin}/zcli --version")
      system "#{bin}/zcli", "help"
    end
  end
  