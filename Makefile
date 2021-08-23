#**************************************************************************
#*                                                                        *
#*                                 OCaml                                  *
#*                                                                        *
#*            Xavier Leroy, projet Cristal, INRIA Rocquencourt            *
#*                                                                        *
#*   Copyright 1997 Institut National de Recherche en Informatique et     *
#*     en Automatique.                                                    *
#*                                                                        *
#*   All rights reserved.  This file is distributed under the terms of    *
#*   the GNU General Public License.                                      *
#*                                                                        *
#**************************************************************************

VERSION = $(shell grep "^version" caml-mode.opam \
	| sed -e 's/version: *"\([^"]*\)"/\1/')
DESCRIPTION = $(shell grep ';;; caml.el ---' caml.el \
	| sed 's/[^-]*--- *\(.*\)/\1/')
DIST_DIR = caml-mode-$(VERSION)
OPAM_DIR = caml-mode.$(VERSION)
TARBALL = caml-mode-$(VERSION).tgz

# Files to install
FILES=	caml-font.el caml.el camldebug.el      \
	inf-caml.el caml-help.el caml-types.el \
	caml-xemacs.el caml-emacs.el

DIST_FILES = $(FILES) Makefile README* COPYING* CHANGES.md ocamltags.in

# Where to install. If empty, automatically determined.
#EMACSDIR=

# Name of Emacs executable
EMACSFORMACOSX = /Applications/Emacs.app/Contents/MacOS/Emacs
EMACSMACPORTS = /Applications/MacPorts/Emacs.app/Contents/MacOS/Emacs
AQUAMACS = $(shell test -d /Applications \
	&& find /Applications -type f | grep 'Aquamacs$$')
ifeq ($(wildcard $(EMACSFORMACOSX)),$(EMACSFORMACOSX))
EMACS ?= $(EMACSFORMACOSX)
else
ifeq ($(wildcard $(EMACSMACPORTS)),$(EMACSMACPORTS))
EMACS ?= $(EMACSMACPORTS)
else
ifneq ($(strip $(AQUAMACS)),)
ifeq ($(wildcard $(AQUAMACS)),$(AQUAMACS))
EMACS ?= $(AQUAMACS)
endif
endif
endif
endif
EMACS ?= emacs

# Where to install ocamltags script
SCRIPTDIR = $(BINDIR)

# Command for byte-compiling the files
COMPILECMD=(progn \
	      (setq load-path (cons "." load-path)) \
	      (byte-compile-file "caml-xemacs.el") \
	      (byte-compile-file "caml-emacs.el") \
	      (byte-compile-file "caml.el") \
	      (byte-compile-file "inf-caml.el") \
	      (byte-compile-file "caml-help.el") \
	      (byte-compile-file "caml-types.el") \
	      (byte-compile-file "caml-font.el") \
	      (byte-compile-file "camldebug.el"))

install:
	@if test "$(EMACSDIR)" = ""; then \
	  $(EMACS) --batch --eval 't; see PR#5403'; \
	  set xxx `($(EMACS) --batch --eval "(mapcar 'print load-path)") \
				2>/dev/null | \
	           sed -n -e 's/^"\(.*\/site-lisp\).*/\1/gp' | \
		   sort -u`; \
	  if test "$$2" = "" -o "$$3" != ""; then \
	    echo "Cannot determine Emacs site-lisp directory:"; \
            shift; while test "$$1" != ""; do echo "\t$$1"; shift; done; \
	  else \
	  $(MAKE) EMACSDIR="$$2" simple-install; \
	  fi; \
	else \
	  $(MAKE) simple-install; \
	fi

# install the .el files, but do not compile them.
install-el:
	$(MAKE) NOCOMPILE=true install

simple-install:
	@echo "Installing in $(EMACSDIR)..."
	if test -d $(EMACSDIR); then : ; else mkdir -p $(EMACSDIR); fi
	$(INSTALL_DATA) $(FILES) $(EMACSDIR)
	if [ -z "$(NOCOMPILE)" ]; then \
	  cd $(EMACSDIR); $(EMACS) --batch --eval '$(COMPILECMD)'; \
	fi

ocamltags:	ocamltags.in
	sed -e 's:@EMACS@:$(EMACS):' ocamltags.in >ocamltags
	chmod a+x ocamltags

install-ocamltags: ocamltags
	$(INSTALL_DATA) ocamltags $(SCRIPTDIR)/ocamltags

# OPAM
.PHONY: opam
opam: $(TARBALL)
	mkdir -p $(OPAM_DIR)
	cp -a caml-mode.opam $(OPAM_DIR)/opam
	echo "url {" >> $(OPAM_DIR)/opam
	echo "  src: \"`pwd`/https://github.com/ocaml/caml-mode/releases/download/$(VERSION)/$(TARBALL)\"" >> $(OPAM_DIR)/opam
	echo "  checksum: \"md5=`md5sum $(TARBALL) | cut -d ' ' -f 1`\"" \
	  >> $(OPAM_DIR)/opam
	echo "}" >> $(OPAM_DIR)/opam

$(TARBALL): $(DIST_FILES)
	mkdir -p $(DIST_DIR)
	for f in $(DIST_FILES); do cp $$f $(DIST_DIR); done
	echo "(define-package \"caml\" \"$(VERSION)\" \"$(DESCRIPTION)\" \
		)" > $(DIST_DIR)/caml-pkg.el
	tar acvf $@ $(DIST_DIR)
	$(RM) -rf $(DIST_DIR)

# This is for testing purposes
compile-only:
	$(EMACS) --batch --eval '$(COMPILECMD)'

clean:
	rm -f ocamltags *~ \#*# *.elc
	$(RM) -r $(TARBALL) $(OPAM_DIR)
