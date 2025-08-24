class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.1.9"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.9/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "2422c49a062f08c71deba6a6dbdeda0f125aba2d4d6641fb298c91bc5743e5ff"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.9/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "545e2016d4d5e3057cde6c82a254801db866a748e2c335b9107dcb1294174d12"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.9/oboi-dlp-linux-amd64.tar.gz"
      sha256 "b08d862bee9251e747bcc78f3f1c73441852ac9f97b2b623961a81d3fe16e0c2"
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
