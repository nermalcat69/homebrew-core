class Zcli < Formula
    desc "Zerops command line utility"
    homepage "https://github.com/zeropsio/zcli"
    version "1.0.41"
    license "MIT"
  
    if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/zeropsio/zcli/releases/download/v1.0.41/zcli-darwin-arm64-npm.tar.gz"
      sha256 "<SHA256_FOR_ARM64_MAC>"
    elsif OS.mac? && Hardware::CPU.intel?
      url "https://github.com/zeropsio/zcli/releases/download/v1.0.41/zcli-darwin-amd64-npm.tar.gz"
      sha256 "<SHA256_FOR_INTEL_MAC>"
    elsif OS.linux? && Hardware::CPU.intel?
      url "https://github.com/zeropsio/zcli/releases/download/v1.0.41/zcli-linux-amd64-npm.tar.gz"
      sha256 "<SHA256_FOR_LINUX_AMD64>"
    else
      odie "Unsupported platform for zcli"
    end
  
    def install
      bin.install "zcli"
    end
  
    test do
      system "#{bin}/zcli", "--version"
    end
  end
  