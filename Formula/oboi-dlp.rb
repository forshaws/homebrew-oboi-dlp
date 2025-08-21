class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.1.5"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.5/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "29a99bc319fa02475519e078c437034c0613abe200e629acb2e598421dc6a18e"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.5/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "017bfeb8ef11319727437eb60af943e32ec4b01d16755957e4ca2c71a2d050a7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.5/oboi-dlp-linux-amd64.tar.gz"
      sha256 "1d976921f0989af192d35cad90660b0e5f18c0ec5e9cc17851a981dd4bcf5422"
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
