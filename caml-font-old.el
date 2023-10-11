;;****************************************** -*- lexical-binding: t; -*- ***
;;*                                                                        *
;;*                                 OCaml                                  *
;;*                                                                        *
;;*                 Jacques Garrigue and Ian T Zimmerman                   *
;;*                                                                        *
;;*   Copyright 1997 Institut National de Recherche en Informatique et     *
;;*     en Automatique.                                                    *
;;*                                                                        *
;;*   All rights reserved.  This file is distributed under the terms of    *
;;*   the GNU General Public License.                                      *
;;*                                                                        *
;;**************************************************************************

;; useful colors

(require 'font-lock)
(require 'caml)

(defface caml-font-stop-face
  '((t :foreground "White" :background "Red"))
  "Extra faces for documentation.")
(define-obsolete-face-alias 'Stop 'caml-font-stop-face "2023")
(unless (boundp 'font-lock-stop-face)
  (defvar font-lock-stop-face 'caml-font-stop-face)
  (make-obsolete-variable 'font-lock-stop-face
                        "use the `caml-font-stop-face' face instead" "2023"))

(defconst caml-font-lock-keywords
  (list
;stop special comments
   '("\\(^\\|[^\"]\\)\\((\\*\\*/\\*\\*)\\)"
     2 'caml-font-stop-face)
;doccomments
   '("\\(^\\|[^\"]\\)\\((\\*\\*[^*]*\\([^)*][^*]*\\*+\\)*)\\)"
     2 'font-lock-doc-face)
;comments
   '("\\(^\\|[^\"]\\)\\((\\*[^*]*\\*+\\([^)*][^*]*\\*+\\)*)\\)"
     2 'font-lock-comment-face)
;character literals
   (cons (concat caml-quote-char "\\(\\\\\\([ntbr" caml-quote-char "\\]\\|"
                 "[0-9][0-9][0-9]\\)\\|.\\)" caml-quote-char
                 "\\|\"[^\"\\]*\\(\\\\\\(.\\|\n\\)[^\"\\]*\\)*\"")
         ''font-lock-string-face)
;modules and constructors
   '("`?\\_<[A-Z][A-Za-z0-9_']*\\_>" . 'font-lock-function-name-face)
;definition
   (cons (concat
          "\\_<\\(a\\(nd\\|s\\)\\|c\\(onstraint\\|lass\\)"
          "\\|ex\\(ception\\|ternal\\)\\|fun\\(ct\\(ion\\|or\\)\\)?"
          "\\|in\\(herit\\|itializer\\)?\\|let"
          "\\|m\\(ethod\\|utable\\|odule\\)"
          "\\|of\\|p\\(arser\\|rivate\\)\\|rec\\|type"
          "\\|v\\(al\\|irtual\\)\\)\\_>")
         ''font-lock-type-face)
;blocking
   '("\\_<\\(begin\\|end\\|object\\|s\\(ig\\|truct\\)\\)\\_>"
     . 'font-lock-keyword-face)
;control
   (cons (concat
          "\\_<\\(do\\(ne\\|wnto\\)?\\|else\\|for\\|i\\(f\\|gnore\\)"
          "\\|lazy\\|match\\|new\\|or\\|t\\(hen\\|o\\|ry\\)"
          "\\|w\\(h\\(en\\|ile\\)\\|ith\\)\\)\\_>"
          "\\||\\|->\\|&\\|#")
         ''font-lock-reference-face)
   '("\\_<raise\\_>" . font-lock-comment-face)
;labels (and open)
   '("\\(\\([~?]\\|\\_<\\)[a-z][a-zA-Z0-9_']*:\\)[^:=]" 1
     'font-lock-variable-name-face)
   '("\\_<\\(assert\\|open\\|include\\)\\_>\\|[~?][ (]*[a-z][a-zA-Z0-9_']*"
     . 'font-lock-variable-name-face)))

(defconst inferior-caml-font-lock-keywords
  (append
   (list
;inferior
    '("^[#-]" . 'font-lock-comment-face))
   caml-font-lock-keywords))

;; font-lock commands are similar for caml-mode and inferior-caml-mode
(defun caml-mode-font-hook ()
  (setq-local font-lock-defaults '(caml-font-lock-keywords t))
  (font-lock-mode 1))

(add-hook 'caml-mode-hook #'caml-mode-font-hook)

(defun inferior-caml-mode-font-hook ()
  (setq-local font-lock-defaults '(inferior-caml-font-lock-keywords t))
  (font-lock-mode 1))

(add-hook 'inferior-caml-mode-hooks #'inferior-caml-mode-font-hook)

(provide 'caml-font-old)
