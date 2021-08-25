[![NonGNU ELPA](https://elpa.nongnu.org/nongnu/caml.svg)](https://elpa.nongnu.org/nongnu/caml.html)
[![MELPA](https://melpa.org/packages/caml-badge.svg)](https://melpa.org/#/caml)
[![DebianBadge](https://badges.debian.net/badges/debian/stable/elpa-caml/version.svg)](https://packages.debian.org/stable/elpa-caml)

OCaml Emacs mode
================

The files in this archive define a `caml-mode` for Emacs, for editing
[OCaml][] programs, as well as an inferior-caml-mode, to run a toplevel.

Caml-mode supports indentation, compilation and error retrieving,
sending phrases to the toplevel. Moreover support for hilit,
font-lock and imenu was added.

This package is based on the original `caml-mode` for caml-light by
Xavier Leroy, extended with indentation by Ian Zimmerman. For details
see [README.itz](README.itz), which is the README from Ian Zimmerman's
package.

Installation
------------

### NonGNU ELPA and MELPA

The easiest way of installing this package is through [NonGNU ELPA][]
or [MELPA][] ([set it up](https://melpa.org/#/getting-started)).
Just run
[<kbd>M-x package-list-packages</kbd>](https://www.gnu.org/software/emacs/manual/html_node/emacs/Packages.html#Packages).

### OPAM

Alternatively, you can use [OPAM][] and install `caml-mode` and
`user-setup`:

    opam install caml-mode user-setup

### Manual instllation

To use this package, just put the `.el` files in your Emacs load path,
and add the following lines in your [Init File][].

    (add-to-list 'auto-mode-alist '("\\.ml[iylp]?$" . caml-mode))
    (autoload 'caml-mode "caml" "Major mode for editing OCaml code." t)
    (autoload 'run-caml "inf-caml" "Run an inferior OCaml process." t)
    (autoload 'camldebug "camldebug" "Run ocamldebug on program." t)
    (add-to-list 'interpreter-mode-alist '("ocamlrun" . caml-mode))
    (add-to-list 'interpreter-mode-alist '("ocaml" . caml-mode))

or put the `.el` files in, eg. `/usr/share/emacs/site-lisp/caml-mode/`
and add the following line in addtion to the four lines above:

    (add-to-list 'load-path "/usr/share/emacs/site-lisp/caml-mode")

To install the mode itself, edit the Makefile and do

    % make install

To install ocamltags, do

    % make install-ocamltags

To use highlighting capabilities, add **one** of the following two lines
to your [Init File][].  The second one works better on recent versions of
Emacs.

    (if window-system (require 'caml-hilit))
    (if window-system (require 'caml-font))

[`caml.el`](caml.el) and [`inf-caml.el`](inf-caml.el) can be used
collectively, but it might be a good idea to copy `caml-hilit.el` or
`caml-font.el` to you own directory, and edit it to your taste and
colors.

Main key bindings
-----------------

<kbd>TAB</kbd>     indent current line  
<kbd>M-C-q</kbd>   indent phrase  
<kbd>M-C-h</kbd>   mark phrase  
<kbd>C-c C-a</kbd> switch between interface and implementation  
<kbd>C-c C-c</kbd> compile (usually `make`)  
<kbd>C-x`</kbd>    goto next error (also mouse button 2 in the compilation log)

Once you have started caml by M-x run-caml:

<kbd>M-C-x</kbd>   send phrase to inferior caml process  
<kbd>C-c C-r</kbd> send region to inferior caml process  
<kbd>C-c C-s</kbd> show inferior caml process  
<kbd>C-c`</kbd>    goto error in expression sent by <kbd>M-C-x</kbd>

For other bindings, see <kbd>C-h b</kbd>.

Some remarks about the style supported
--------------------------------------

Since OCaml's syntax is very liberal (more than 100
shift-reduce conflicts with yacc), automatic indentation is far from
easy. Moreover, you expect the indentation to be not purely syntactic,
but also semantic: reflecting the meaning of your program.

This mode tries to be intelligent. For instance some operators are
indented differently in the middle and at the end of a line (thanks to
Ian Zimmerman). Also, we do not indent after `if .. then .. else`, when
`else` is on the same line, to reflect that this idiom is equivalent to
a return instruction in a more imperative language, or after the `in` of
`let .. in`, since you may see that as an assignment.

However, you may want to use a different indentation style. This is
made partly possible by a number of variables at the beginning of
`caml.el`. Try to set them. However this only changes the size of
indentations, not really the look of your program. This is enough to
disable the two idioms above, but to do anything more you will have to
edit the code... Enjoy!

This mode does not force you to put `;;` in your program. This means
that we had to use a heuristic to decide where a phrase starts and
stops, to speed up the code. A phrase starts when any of the keywords
`let`, `type`, `class`, `module`, `functor`, `exception`, `val`,
`external`, appears at the beginning of a line. Using the first column
for such keywords in other cases may confuse the phrase selection
function.


[OCaml]: http://ocaml.org/
[OPAM]: https://opam.ocaml.org/
[NonGNU ELPA]: https://elpa.nongnu.org/
[MELPA]: https://melpa.org/
[Init File]: https://www.gnu.org/software/emacs/manual/html_node/emacs/Init-File.html
