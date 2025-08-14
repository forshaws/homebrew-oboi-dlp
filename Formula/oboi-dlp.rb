class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.1.0"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "e229db8d0d506435e0ecddb3d684e114362ba6364938295fa0e43d35428db4b6"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "cceee7ce64c5e3bbe7bad4b560ad438a52a415c51c2e99fd2eb9b6b9b3e7bedb"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-linux-amd64.tar.gz"
      sha256 "b2b6c1c336d5a78978eca6874d93a0765982b02aaae074d08eaa9357e1be942c"
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
