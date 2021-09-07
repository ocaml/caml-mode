4.9 2021-09-7
-------------

* camldebug mode now recognize the new format of code pointers (#7).
* Make the code ready to be distributed in NonGNU ELPA.
* Many warnings fixed (thanks to Stefan Monnier) and minor code improvements.
* XEmacs is no longer supported.

Version 3.10.1
--------------
* use `caml-font.el` from Olivier Andrieu
  old version is left as caml-font-old.el for compatibility

Version 3.07
------------
* support for showing type information _Damien Doligez_

Version 3.05
------------
* improved interaction with inferior caml mode
* access help from the source
* fixes in indentation code

Version 3.03
------------
* process `;;` properly

Version 3.00
------------
* adapt to new label syntax
* intelligent indentation of parenthesis

Version 2.02
------------
* improved ocamltags _ITZ and JG_
* added support for multibyte characters in Emacs 20

Version 2.01+
-------------
* corrected a bug in `caml-font.el` _Adam P. Jenkins_
* corrected abbreviations and added `ocamltags` script _Ian T Zimmerman_

Version 2.01
------------
* code for interactive errors added by ITZ

Version 2.00
------------
* changed the algorithm to skip comments
* adapted for the new object syntax

Version 1.07
------------
* `next-error` bug fix by John Malecki
* `camldebug.el` modified by Xavier Leroy

Version 1.06
------------
* new keywords in Objective Caml 1.06
* compatibility with GNU Emacs 20
* changed from caml-imenu-disable to caml-imenu-enable (off by default)

Version 1.05
------------
* a few indentation bugs corrected. `let`, `val` ... are now indented
  correctly even when you write them at the beginning of a line.
* added a Caml menu, and Imenu support. Imenu menu can be disabled
  by setting the variable `caml-imenu-disable` to `t`.
  Xemacs support for the Menu, but no Imenu.
* key bindings closer to lisp-mode.
* O'Labl compatibility (":" is part of words) may be switched off by
  setting `caml-olabl-disable` to `t`.
* `camldebug.el` was updated by Xavier Leroy.

Version 1.03b
-------------
* many bugs corrected.

* (partial) compatibility with Caml-Light added.

        (setq caml-quote-char "`")
        (setq inferior-caml-program "camllight")

  Literals will be correctly understood and highlighted. However,
  indentation rules are still OCaml's: this just happens to
  work well in most cases, but is only intended for occasional use.
* as many people asked for it, application is now indented. This seems
  to work well: this time differences in indentation between the
  compiler's source and this mode are really exceptionnal. On the
  other hand, you may think that some special cases are strange. No
  miracle.
* nicer behaviour when sending a phrase/region to the inferior caml
  process.

Version 1.03
------------
* support of OCaml and Objective Label.
* an indentation very close to mine, which happens to be the same as
  Xavier's, since the sources of the OCaml compiler do not
  change if you indent them in this mode.
* highlighting.

