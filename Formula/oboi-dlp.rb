class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.1.0"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "34eb7b4a94b1e91dcaf1fa23d055a437854a6608b71625c1b3037a362c7d4886"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "ff629b3dfbaf59c8ddcc5656a66d578f89c2e8a4bfe16e09b9824b25af104d73"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-linux-amd64.tar.gz"
      sha256 "6ab89c1f491813f1fe83579670827943fe70ec62b95b8df951f85d2fa812f807"
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
