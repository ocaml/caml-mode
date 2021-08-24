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

VERSION = $(shell grep "^;; *Version" caml.el \
	| sed -e 's/;; *Version: *\([^ \t]*\)/\1/')
SYNOPSIS = $(shell grep ';;; caml.el ---' caml.el \
	| sed 's/[^-]*--- *\([^-]\+\) \+.*/\1/')
DIST_NAME = caml-mode-$(VERSION)
TARBALL = caml-mode-$(VERSION).tgz
OPAM_FILE = packages/caml-mode/caml-mode.$(VERSION)/opam

# Files to install
FILES=	caml-font.el caml.el camldebug.el      \
	inf-caml.el caml-help.el caml-types.el

INSTALL_DIR ?= $(shell opam var share)/emacs/site-lisp
INSTALL_BIN ?= $(shell opam var bin)

DIST_FILES = $(FILES) Makefile README* COPYING* CHANGES.md ocamltags.in

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

INSTALL_MKDIR = mkdir -p
INSTALL_DATA = cp
INSTALL_RM_R = $(RM) -r

# Command for byte-compiling the files
COMPILECMD=(progn \
	      (setq load-path (cons "." load-path)) \
	      (byte-compile-file "caml.el") \
	      (byte-compile-file "inf-caml.el") \
	      (byte-compile-file "caml-help.el") \
	      (byte-compile-file "caml-types.el") \
	      (byte-compile-file "caml-font.el") \
	      (byte-compile-file "camldebug.el"))

# This is for testing purposes
compile-only:
	$(EMACS) --batch --eval '$(COMPILECMD)'

# install the .el files, but do not compile them.
install-el:
	$(MAKE) NOCOMPILE=true install

install:
	@echo "Installing in $(INSTALL_DIR)..."
	$(INSTALL_MKDIR) $(INSTALL_DIR)
	$(INSTALL_DATA) $(FILES) $(INSTALL_DIR)
	if [ -z "$(NOCOMPILE)" ]; then \
	  cd $(INSTALL_DIR); $(EMACS) --batch --eval '$(COMPILECMD)'; \
	fi

uninstall:
	cd $(INSTALL_DIR) && $(INSTALL_RM_R) $(FILES) $(FILES:.el=.elc)

ocamltags:	ocamltags.in
	sed -e 's:@EMACS@:$(EMACS):' ocamltags.in >ocamltags
	chmod a+x ocamltags

install-ocamltags: ocamltags
	$(INSTALL_DATA) ocamltags $(INSTALL_BIN)/ocamltags

uninstall-ocamltags:
	$(INSTALL_RM_R) $(INSTALL_BIN)/ocamltags

tarball: $(TARBALL)
$(TARBALL): $(DIST_FILES)
	$(INSTALL_MKDIR) $(DIST_NAME)
	for f in $(DIST_FILES); do cp $$f $(DIST_NAME); done
	echo "(define-package \"caml\" \"$(VERSION)\" \"$(SYNOPSIS)\")" \
	     > $(DIST_NAME)/caml-pkg.el
	tar acvf $@ $(DIST_NAME)
	$(INSTALL_RM_R) $(DIST_NAME)

submit: $(TARBALL)
	@if [ ! -d packages/ ]; then \
	  echo "Make a symbolic link packages → OPAM repository/packages"; \
	  exit 1; \
	fi
	$(INSTALL_MKDIR) $(dir $(OPAM_FILE))
	sed -e "s/VERSION/$(VERSION)/" -e 's/SYNOPSIS/$(SYNOPSIS)/' \
	  caml-mode.opam > $(OPAM_FILE)
	echo "url {" >> $(OPAM_FILE)
	echo "  src: \"https://github.com/ocaml/caml-mode/releases/download/$(VERSION)/$(TARBALL)\"" >> $(OPAM_FILE)
	echo "  checksum: \"md5=`md5sum $(TARBALL) | cut -d ' ' -f 1`\"" \
	  >> $(OPAM_FILE)
	echo "}" >> $(OPAM_FILE)

clean:
	rm -f ocamltags *~ \#*# *.elc
	$(RM) -r $(TARBALL)


.PHONY: install uninstall install-el \
	ocamltags install-ocamltags uninstall-ocamltags \
        tarball submit compile-only clean
