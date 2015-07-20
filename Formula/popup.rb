class Popup < Formula
  desc "Visual popup interface library for Emacs"
  homepage "https://github.com/auto-complete/popup-el"
  url "https://github.com/auto-complete/popup-el/archive/v0.5.2.tar.gz"
  sha256 "19714326dd5166def540c3f1c47a27e67ffdb3a94c91271c88a8500a15846c0b"
  head "https://github.com/auto-complete/popup-el.git"

  depends_on :emacs => "23"
  depends_on "cask"

  def install
    # otherwise a buffer pops up with the test results
    inreplace "Makefile", "$(CASK) exec $(EMACS) -Q",
                          "$(CASK) exec $(EMACS) -Q --batch"
    system "make", "test", "EMACS=#{which "emacs"}",
                           "CASK=#{Formula["cask"].bin}/cask"

    (share/"emacs/site-lisp/popup").install "popup.el"
    doc.install "README.md"
  end
end
