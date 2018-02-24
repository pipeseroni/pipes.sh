PREFIX=/usr/local
DESTDIR=

INSTDIR=$(DESTDIR)$(PREFIX)
INSTBIN=$(INSTDIR)/bin
INSTMAN=$(INSTDIR)/share/man/man6

SCRIPT=pipes.sh
MANPAGE=$(SCRIPT).6

all:
	@echo did nothing. try targets: install, or uninstall.

install:
	test -d $(INSTDIR) || mkdir -p $(INSTDIR)
	test -d $(INSTBIN) || mkdir -p $(INSTBIN)
	test -d $(INSTMAN) || mkdir -p $(INSTMAN)

	install -m 0755 $(SCRIPT) $(INSTBIN)
	install -m 0644 $(MANPAGE) $(INSTMAN)

uninstall:
	rm -f $(INSTBIN)/$(SCRIPT)
	rm -f $(INSTMAN)/$(MANPAGE)

.PHONY: all install uninstall
