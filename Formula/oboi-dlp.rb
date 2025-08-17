class OboiDlp < Formula
  desc "oboi-dlp — A fast efficient DLP tool for Apache systems"
  homepage "https://toridion.com/oboi-dlp/"
  version "0.1.3"  # change if you use a different tag

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.3/oboi-dlp-darwin-arm64.tar.gz"
      sha256 "6e2906e777fae11ac9f7fd96bf3df82136e6b6c1728b92ac0352edd8e278f8ff"
    else
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.3/oboi-dlp-darwin-amd64.tar.gz"
      sha256 "58d91ee0814e24c2c95a7242c82ca67460ec14138f41a1b60da6940c6edfed10"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/forshaws/homebrew-oboi-dlp/releases/download/v0.1.3/oboi-dlp-linux-amd64.tar.gz"
      sha256 "6a73a86c67db7a8f4a1355c7ba0bcef175603c7fc4aeacd5468c99dc046a8738"
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
