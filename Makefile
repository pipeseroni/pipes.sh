PREFIX=/usr/local
DESTDIR=

INSTDIR=$(DESTDIR)$(PREFIX)
INSTBIN=$(INSTDIR)/bin

SCRIPT=pipes.sh

all:
	@echo did nothing. try targets: install, or uninstall.

install:
	test -d $(INSTDIR) || mkdir -p $(INSTDIR)
	test -d $(INSTBIN) || mkdir -p $(INSTBIN)

	install -m 0755 $(SCRIPT) $(INSTBIN)

uninstall:
	rm -f $(INSTBIN)/$(SCRIPT)

.PHONY: all install uninstall
