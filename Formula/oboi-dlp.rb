class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.2.2"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.2.2/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "e9f5a9401f0e4d687a42793dc7775d53f780f468ee5d66e678c8f8b7f1b74847"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.2.2/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "040001974315f16ba47dbca5cdfe3963165f4696be7935179e173c266de9c5e4"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.2.2/oboi-dlp-linux-amd64.tar.gz"
      sha256 "1163a9c6a6630bb0c36fa822da9fd2810e71c2af72b65ab4b1f4be4bbab63922"
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
