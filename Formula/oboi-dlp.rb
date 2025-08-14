class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.1.0"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "8c429617ee465c5dd8f7936eb14e8c3e09ff5145c6efb5f3118fbf1961a70ee3"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "bb128e88be7f225e34f4e02fa06c1538d5d912cc647af95deb8becac07c54d25"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.0/oboi-dlp-linux-amd64.tar.gz"
      sha256 "51146c2d2e8db6cb7394a9a3a355f9372e38ca731c937a8a985756601cae1842"
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
