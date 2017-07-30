document_dir=$(prefix)/share/doc/@PACKAGE@

EXTRA_DIST = Doxyfile.in

# ensure doxygen-build.stamp is included,
# or else the documentation will not be built or distributed
noinst_DATA = doxygen-build.stamp

if HAVE_DOXYGEN
doxygen-build.stamp: Doxyfile $(top_srcdir)/include/skeleton/*.h
	doxygen
	touch doxygen-build.stamp
else
doxygen-build.stamp:
	echo "*** Warning: Doxygen not found; documentation will not be built."
	touch doxygen-build.stamp
endif

dist_docdir = $(distdir)/libskeleton

dist-hook:
	if test -d libskeleton; then \
	 mkdir $(dist_docdir); \
	  for dir in libskeleton/*; do \
	   b=`basename $$dir`; \
            if test $$b != "CVS"; then \
              if test -d $$dir; then \
                mkdir $(dist_docdir)/$$b; \
                for f in $$dir/*; do \
                  cp -p $$f $(dist_docdir)/$$b; \
                done \
              fi \
            fi \
          done \
        fi

install-data-local: doxygen-build.stamp
	$(mkinstalldirs) $(DESTDIR)$(document_dir)
	if test -d libskeleton; then \
          for dir in libskeleton/*; do \
            if test -d $$dir; then \
              b=`basename $$dir`; \
              $(mkinstalldirs) $(DESTDIR)$(document_dir)/$$b; \
              for f in $$dir/*; do \
                $(INSTALL_DATA) $$f $(DESTDIR)$(document_dir)/$$b; \
              done \
            fi \
          done \
        fi

uninstall-local:
	rm -rf $(DESTDIR)$(document_dir)

clean-local:
	if test -d libskeleton; then rm -rf libskeleton; fi
	if test -f doxygen-build.stamp; then rm -f doxygen-build.stamp; fi
	
