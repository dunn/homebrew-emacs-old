require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ElispBugHunter < EmacsFormula
  desc "Emacs library for debugging elisp configuration files"
  homepage "https://github.com/Malabarba/elisp-bug-hunter"
  url "http://elpa.gnu.org/packages/bug-hunter-0.5.el"
  sha256 "564a35f95326a00cc44275aaa9f85bf5d2bb98ac92875dd0c428c2fe10a7bce5"
  head "https://github.com/Malabarba/elisp-bug-hunter.git"

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/seq"

  def install
    mv "bug-hunter-#{version}.el", "bug-hunter.el" if build.stable?

    if build.head?
      ert_run_tests "bug-hunter-test.el"
      doc.install "README.org"
    end

    byte_compile "bug-hunter.el"
    (share/"emacs/site-lisp/bug-hunter").install "bug-hunter.el",
                                                 "bug-hunter.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'bug-hunter)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/bug-hunter")
      (add-to-list 'load-path "#{Formula["dunn/emacs/seq"].share}/emacs/site-lisp/seq")
      (load "bug-hunter")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
