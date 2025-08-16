class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.1.2"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.2/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "df130cde9f87a6260f1deb652496d1bc5024ad90181e14266b1053f08efd0bae"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.2/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "a9ec52dfda3df1a63a43e4937ccc8fef3c3b793272c035476ee7a8ca89b7f8e1"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.2/oboi-dlp-linux-amd64.tar.gz"
      sha256 "b1324640c0560f94f509a717f2167fb419b9a44811609d94bbcdab56fd385f9d"
    else
      odie "No Linux ARM build available"
    end
  end

  def install
    bin.install "oboi-dlp"
    etc.install "oboi-dlp.conf"
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
