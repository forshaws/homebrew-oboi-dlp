class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.1.1"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "05714ebe83536b7d0fd266383c67f46b897400db4aec8d19b5eba580d626adf4"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "e399b889090b0faa00f1c63c802d836ac7dfdc40628175a150b7b8d328e69003"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-linux-amd64.tar.gz"
      sha256 "1b57982f3613a3cc501b560a48d98eecad8f600820a0450e62534882676c588c"
    else
      odie "No Linux ARM build available"
    end
  end

  def install
    bin.install "oboi-dlp"
  end

  test do
    # Adjust to an actual test your binary supports
    system "#{bin}/oboi-dlp", "--version"
  end
end
