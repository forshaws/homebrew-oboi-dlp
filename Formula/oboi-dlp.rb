class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.2.3"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.2.3/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "4b0fe939796beafa57ae1f18752a4bb525be0bb651df2de535fcd707b16f8d60"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.2.3/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "4597d94b2eb391bf1f75faceb45038f67751cdd878e066206377125c8f13da54"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.2.3/oboi-dlp-linux-amd64.tar.gz"
      sha256 "c021a1c5c8fca9978170e1991cf049b93903252934bd9618a1a7b61a552a1c5e"
    else
      odie "No Linux ARM build available"
    end
  end

  def install

    bin.install "oboi-dlp"
    etc.install "oboi-dlp.conf"
    pkgshare.install "oboi-dlp-test"
    
    # Create log directory
    #log_dir = var/"log/oboi-dlp"
    #log_dir.mkpath

    # Optional: set permissions so non-root users (or Apache _www) can write
    #log_dir.chmod 0755
  end
  
  def caveats
    <<~EOS
	  A default config has been installed to:
	    #{etc}/oboi-dlp.conf
	  Edit this file to suit your needs.

	  To test oboi-dlp with Apache, copy the test suite into your web root:
	    sudo cp -r #{opt_pkgshare}/oboi-dlp-test /var/www/html/

	  Then run the included test script:
	    cd /var/www/html/oboi-dlp-test
	    ./make_oboi_dlp_fixtures.sh

	  Open http://127.0.0.1/oboi-dlp-test/test_oboi_dlp.html in your browser to verify.
    EOS
  end

  test do
    # version
    system "#{bin}/oboi-dlp", "--version"
  end
end
