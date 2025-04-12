class Zcli < Formula
    desc "Zerops command line utility"
    homepage "https://github.com/zeropsio/zcli"
    url "https://github.com/zeropsio/zcli/releases/download/v1.0.42/zcli-darwin-arm64-npm.tar.gz"
    sha256 "1fca91d550a9705d052f0fc87ba32c745619cb15b161268d0cfcdcca98f9a253"
    license "MIT"
  
    depends_on "wireguard-tools"
  
    def install
        bin.install "builds/zcli-darwin-arm64" => "zcli"
    end    
  
    test do
      assert_match "zcli version", shell_output("#{bin}/zcli --version")
    end
  
    livecheck do
      url :stable
      strategy :github_latest
    end
  end
  