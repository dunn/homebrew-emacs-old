require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TnfaEmacs < EmacsFormula
  desc "Tagged non-deterministic finite-state automata, in Emacs"
  homepage "http://www.dr-qubit.org/emacs.php"
  url "http://www.dr-qubit.org/download.php?file=predictive/tNFA-0.1.1.el"
  sha256 "e61159c523166252709855ab5c71ea3aebea381d50e269c2dbc769b4d02d45ec"

  depends_on :emacs
  depends_on "dunn/emacs/queue-emacs"

  def install
    mv "tNFA-#{version}.el", "tNFA.el"
    byte_compile "tNFA.el"
    (share/"emacs/site-lisp/tNFA").install "tNFA.el", "tNFA.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/tnfa")
      (add-to-list 'load-path "#{Formula["queue-emacs"].share}/emacs/site-lisp/queue")
      (load "tNFA")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
