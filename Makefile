TARGET=pipes
PREFIX=/usr/local
DESTDIR=
BINDIR=$(PREFIX)/bin

all:
	@echo Try: install or uninstall.

install:
	install -Dm755 $(TARGET).sh $(DESTDIR)$(BINDIR)/$(TARGET)
	install -Dm755 $(TARGET)_orig.sh $(DESTDIR)$(BINDIR)/$(TARGET)_orig

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/$(TARGET)
	rm -f $(DESTDIR)$(BINDIR)/$(TARGET)_orig 

.PHONY: all install uninstall
