PREFIX?=/usr/local
DESTDIR=

INSTDIR=$(DESTDIR)$(PREFIX)
INSTBIN=$(INSTDIR)/bin
INSTMAN=$(INSTDIR)/share/man/man6

BIN ?= pipes.sh
SCRIPT=pipes.sh
MANPAGE=$(BIN).6

all:
	@echo did nothing. try targets: install, or uninstall.

install:
	test -d $(INSTDIR) || mkdir -p $(INSTDIR)
	test -d $(INSTBIN) || mkdir -p $(INSTBIN)
	test -d $(INSTMAN) || mkdir -p $(INSTMAN)

	install -m 0755 $(SCRIPT) $(INSTBIN)/$(BIN)
	install -m 0644 doc/$(MANPAGE) $(INSTMAN)

uninstall:
	rm -f $(INSTBIN)/$(BIN)
	rm -f $(INSTMAN)/$(MANPAGE)

.PHONY: all install uninstall
