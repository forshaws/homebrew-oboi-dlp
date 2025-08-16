class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.1.2"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.2/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "04c2a2063186470b1f0c80d3c65c4e6bd2c135d7882d6b24c833dca80052e498"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.2/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "c7ac1df1b079e71ca715e78a43c766e5288acbc368ca1dbcb7a542bc0ea0ee5b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.2/oboi-dlp-linux-amd64.tar.gz"
      sha256 "bf5746c65fcbe2ff99558acec584fa35f5d85f969a222aabc6579d4fa4ac8e72"
    else
      odie "No Linux ARM build available"
    end
  end

  def install
    bin.install "oboi-dlp"
    
    # Install default config
    etc.install "oboi-dlp.conf"
    
    
	# Install test files into pkgshare
    pkgshare.install "oboi-dlp-test"
    
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
    # Adjust to an actual test your binary supports
    system "#{bin}/oboi-dlp", "--version"
  end
end
