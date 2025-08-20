class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.1.4"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.4/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "e75c986ea947cb76c2b3a1f9d867d4b0fc53dbda27e404fda31daa120a1a0035"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.4/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "5c9f64b25ffcb26c1b301993c3587e6c0345f29fbceca0ad74d0d7be7750b5d3"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.4/oboi-dlp-linux-amd64.tar.gz"
      sha256 "b40d20ffc551aa83098ed2c6a94c6e9c0b908317c4d2318063511f2eb7c3a4bf"
    else
      odie "No Linux ARM build available"
    end
  end

  def install
    bin.install "oboi-dlp"
    etc.install "oboi-dlp.conf"
    pkgshare.install "oboi-dlp-test"
    
    # Create log directory
    log_dir = var/"log/oboi-dlp"
    log_dir.mkpath

    # Optional: set permissions so non-root users (or Apache _www) can write
    log_dir.chmod 0755
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
