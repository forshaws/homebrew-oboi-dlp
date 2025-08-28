class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.2.0"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.2.0/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "cb10a644839b2572d216323c27afb7cc7dc6fd1de80da606f93123176b49b686"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.2.0/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "c3aaab53270aab03ee35f54f96f38ecfef437d7994192e274d02c58436113f01"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.2.0/oboi-dlp-linux-amd64.tar.gz"
      sha256 "adc47f76430ebaf01cdcb70d77b6511092345b394314fbb8ddc3da413241233c"
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
