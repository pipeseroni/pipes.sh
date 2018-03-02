PREFIX=/usr/local
DESTDIR=

INSTDIR=$(DESTDIR)$(PREFIX)
INSTBIN=$(INSTDIR)/bin
INSTMAN=$(INSTDIR)/share/man/man6

SCRIPT=pipes.sh
MANPAGE=$(SCRIPT).6


all:
	@echo did nothing. try targets: install, or uninstall.
.PHONY: all


# this target is intended for an HTML version of manpage to be displayed on
# GitHub Pages, so if there is a such named directory, it will also copy the
# generated HTML to the directory.
$(MANPAGE).html: $(MANPAGE)
	TZ=UTC scripts/gen-man-html.sh '$^' '$@'
	test -d gh-pages && cp -a $@ gh-pages/ || true


clean:
	$(RM) $(MANPAGE).html
.PHONY: clean


test:
	bats test
.PHONY: test


install:
	test -d $(INSTDIR) || mkdir -p $(INSTDIR)
	test -d $(INSTBIN) || mkdir -p $(INSTBIN)
	test -d $(INSTMAN) || mkdir -p $(INSTMAN)

	install -m 0755 $(SCRIPT) $(INSTBIN)
	install -m 0644 $(MANPAGE) $(INSTMAN)
.PHONY: install


uninstall:
	rm -f $(INSTBIN)/$(SCRIPT)
	rm -f $(INSTMAN)/$(MANPAGE)
.PHONY: uninstall
